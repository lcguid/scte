#!/usr/bin/perl -w          

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

$Term::ANSIColor::AUTORESET = 1;


# use Term::ANSIColor qw(:constants);
# 
# require "lib/read_configurations.pl";
# require "lib/user_defined/legacy.pl";
# require "lib/user_defined/experiment.pl";

#__ VARIABLE DECLARATIONS _____________________________________________________

#__ for Configurations __
my %general_confs;
my %device_1_confs;

#__ for Devices __
my $device_1;

#__ for Readings __
my $device_1_readings;
my $file_name;

#__ for File Descriptors  __
my $output_file;

#__ for Auxiliary Purposes __
my $debug = 1; # [1 | undef]
my $stdout_flush;


#__ COMMAND LINE PARSER _______________________________________________________
&usage() if( !defined @ARGV || $#ARGV != 0 );

$file_name = $ARGV[0];


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

if( $general_confs{DEVICE_1_BUS} =~ /^LAN$/ )
{
  $device_1->SetPortNumber( $general_confs{DEVICE_1_PORT_NUMBER} );
}

$device_1->SetConfigurations( \%device_1_confs );

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

&InitializeStorage( \%general_confs, \$output_file, \$file_name );

&RunExperiment( $device_1, \$device_1_readings );

$device_1_readings = "";

&WriteData( \$output_file, \$device_1_readings );  

&CloseStorage( \$output_file );
  
exit;

