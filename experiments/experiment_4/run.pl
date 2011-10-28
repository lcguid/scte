#!/usr/bin/perl -w          
=pod
 Copyright 2004-2011 Luiz Carlos Büttner Mostaço-Guidolin
 
 This file is part of SCTE.

 SCTE is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 SCTE is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with SCTE. If not, see <http://www.gnu.org/licenses/>.
=cut

use strict ;
use Term::ANSIColor qw(:constants) ;

require "lib/read_configurations.pl"
require "lib/user_defined/legacy.pl" ;
require "lib/user_defined/experiment.pl" ;

&usage() if( !defined @ARGV || $#ARGV > 0 ) ;

&ReadConfigurations( "etc/general.conf", \%confs );
&ReadConfigurations(
  "etc/$general_confs{DEVICE_1_CONFIGURATION}",
  \%device_1_confs
);

my $device1 = $confs{DEVICE_1_PATH} ;

# If there is another printing process running it stops it
&SerialWrite( $device1, "HARDCopy ABOrt" ) ;
  
if( ! defined &setExperimentParameters( $device1 , \%Osciloscope_parametes ) )
{
  print BOLD RED "\nScree Capture Aborted!\n\n" ;
  exit ;
}
  
&ScreenCapture( "$ARGV[0]" ) ; 
  
exit ;

sub usage
{
  print "USAGE: ScreenCapture.pl <output file>  \n";
  exit ;
}
