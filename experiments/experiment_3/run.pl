#!/usr/bin/perl

#______________________________________________________________________________ 
#
# Copyright 2004-2012 Luiz C. Mostaço-Guidolin
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

use Term::ANSIColor qw(:constants);
use SCTE::Instrument;

require "lib/signal_handler.pl";
require "lib/read_configurations.pl";
require "lib/user_defined/usage.pl";
require "lib/user_defined/experiment.pl";
require "lib/user_defined/storage.pl";
require "lib/user_defined/analysis.pl";

$Term::ANSIColor::AUTORESET = 1;

#__ VARIABLE DECLARATIONS _____________________________________________________

#__ for Configurations __
my %general_confs; # my %confs;
my %device_1_confs;

#__ for Devices __
my $device_1;

#__ for Readings __
my $device_1_readings;
my %scale_factors;

#__ for File Descriptors  __
my $output_file;

#__ for Auxiliary Purposes __
my $channel;
my $debug = 1; # [1 | undef]
my $stdout_flush;


#__ COMMAND LINE PARSER _______________________________________________________
&usage() if( !defined @ARGV || $#ARGV != 0 );

$channel = $ARGV[0];


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

%scale_factors = (
  "WFMPre:${channel}:XZEro"  => "",
  "WFMPre:${channel}:XINcr"  => "",
  "WFMPre:${channel}:PT_OFf" => "",
  "WFMPre:${channel}:YZEro"  => "",
  "WFMPre:${channel}:YMUlt"  => "",
  "WFMPre:${channel}:YOFf"   => "" 
);

#__ Storage __
$device_1_readings = undef;

#__ File Descriptors __
$output_file = undef;

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


#__ EXPERIMENT  _______________________________________________________________

&InitializeStorage( \%general_confs, \$output_file );

&RunExperiment(
  \%general_confs,
  $device_1,
  \$device_1_readings,
  \$channel,
  \%scale_factors
);


$device_1_readings = "13,6,3,2,-1,-9,-14,-19,-29,-35,-67,-1,-78,-62,
-50,-31,-27,-7,0,12,29,39,45,43,41,47,41,38,33,26";

&AnalyseReadings( \$device_1_readings, \$channel );

&WriteData( \$output_file, \$device_1_readings );  

&CloseStorage( \$output_file );

exit;

