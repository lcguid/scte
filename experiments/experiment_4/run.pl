#!/usr/bin/perl -w          

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


use strict;
use Term::ANSIColor qw(:constants);

require "lib/read_configurations.pl";
require "lib/user_defined/legacy.pl";
require "lib/user_defined/experiment.pl";

&usage() if( !defined @ARGV || $#ARGV > 0 );

my $device1;
my %confs;
my %device_1_confs;

&ReadConfigurations( "etc/general.conf", \%confs );
&ReadConfigurations(
  "etc/$confs{DEVICE_1_CONFIGURATION}",
  \%device_1_confs
);

# If there is another printing process running it stops it
&SerialWrite( $confs{DEVICE_1_PATH}, "HARDCopy ABOrt" );
  
if( ! defined &setExperimentParameters( $confs{DEVICE_1_PATH} , \%device_1_confs ) )
{
  print BOLD RED "\nScree Capture Aborted!\n\n";
  exit;
}
  
&ScreenCapture( $confs{DEVICE_1_PATH}, "$ARGV[0]" ); 
  
exit;

sub usage
{
  print "USAGE: ScreenCapture.pl <output file>  \n";
  exit;
}
