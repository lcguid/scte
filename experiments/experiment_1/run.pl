#!/usr/bin/env perl 

#______________________________________________________________________________ 
#
# Copyright 2004-2011 Luiz C. Mostaço-Guidolin
# 
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later 
# version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#______________________________________________________________________________

use warnings;
use strict;

use sigtrap 'handler', \&SignalHandler, qw( QUIT normal-signals);

use Math::GSL::Vector qw(:all);
use Term::ANSIColor qw(:constants);
use SCTE::Instrument;

require "lib/signal_handler.pl";
require "lib/read_configurations.pl";
require "lib/user_defined/experiment.pl";
require "lib/user_defined/storage.pl";
require "lib/user_defined/analysis.pl";

$Term::ANSIColor::AUTORESET = 1;


#__ VARIABLE DECLARATIONS _____________________________________________________

#__ for Configurations __
my %general_confs;
my %device_1_confs;

#__ for Devices __
my $device_1;

#__ for Readings __
my %device_1_readings;
my %device_1_readings_avg;
my %device_1_readings_sderr;

#__ for File Descriptors  __
my %files;

#__ for Auxiliary Purposes __
my $debug = 1; # [1 | undef]
my $stdout_flush;


#__ READ CONFIGURATION FILES __________________________________________________

&ReadConfigurations( "etc/general.conf", \%general_confs );
&ReadConfigurations(
  "etc/$general_confs{DEVICE_1_CONFIGURATION}",
  \%device_1_confs
);


#__ INITIALIZATIONS ___________________________________________________________

#__ Devices __
$device_1 = SCTE::Instrument->new();

$device_1->SetDevice( $general_confs{DEVICE_1_PATH} );
$device_1->SetBUS( $general_confs{DEVICE_1_BUS} );
$device_1->SetDelay( $general_confs{DEVICE_1_DELAY} );
$device_1->SetConfigurations( \%device_1_confs );

#__ Storage __
$device_1_readings{CH1_Pk2Pk} = undef;
$device_1_readings{CH2_Pk2Pk} = undef;
$device_1_readings{CH1_Freq} = undef;
$device_1_readings{CH2_Freq} = undef;

$device_1_readings_avg{CH1_Pk2Pk} = undef;
$device_1_readings_avg{CH2_Pk2Pk} = undef;
$device_1_readings_avg{CH1_Freq} = undef;
$device_1_readings_avg{CH2_Freq} = undef;

$device_1_readings_sderr{CH1_Pk2Pk} = undef;
$device_1_readings_sderr{CH2_Pk2Pk} = undef;
$device_1_readings_sderr{CH1_Freq} = undef;
$device_1_readings_sderr{CH2_Freq} = undef;

#__ File Descriptors __
$files{RAW_DATA} = undef;
$files{ANALYSED} = undef;

#__ Misc __
$stdout_flush = select( STDOUT );
    $| = 1;
select( $stdout_flush );


#__ COMMUNICATION TESTS _______________________________________________________

print BOLD BLUE "\nTesting communication with Device 1: ";

{
  my $reply = $device_1->Write( "*IDN?" );
  
  if( ! $reply ) { print BOLD RED "[FAILED] \n"; }
  else { print BOLD GREEN $reply . "\n"; }
}


#__ DEVICE CONFIGURATION ______________________________________________________

print BOLD BLUE "Configuring Device 1: ";

# Stops printing the header of each command
$device_1->Write( "HEADer off" ); 
$device_1->Configure();

print BOLD GREEN "[DONE] \n";

$device_1->CheckConfigurations();


#__ EXPERIMENT CONFIGURATION __________________________________________________
foreach( keys %device_1_readings )
{ 
  $device_1_readings{$_} = Math::GSL::Vector->new(
    $general_confs{READINGS_PER_POINT}
  );
}


#__ EXPERIMENT  _______________________________________________________________

my $file_to_plot = &InitializeStorage( \%general_confs, \%files ); 
&WriteFileHeaders( \%files );

do
{
  &RunExperiment( \%general_confs, $device_1, \%device_1_readings );

  &AnalyseReadings(
    \%device_1_readings,
    \%device_1_readings_avg,
    \%device_1_readings_sderr
  );

  &WriteData(
    \%files, 
    \%device_1_readings,
    \%device_1_readings_avg,
    \%device_1_readings_sderr
  );

  open( GNUPLOT, "|$general_confs{PLOT_APP_PATH} -p" );
print GNUPLOT <<EOPLOT;
unset key 
set xlabel "Input Signal (V)"
set ylabel "Output Signal (V)"
plot "$file_to_plot" using 1:5:(sqrt(\$2*\$2+\$6*\$6)) with yerrorbars
EOPLOT
  close(GNUPLOT);	

  print "\n-> Continue[Y/n]? ";
  
} while <STDIN> !~ /^n$/;

&CloseStorage( \%files );

exit;
