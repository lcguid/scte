#!/usr/bin/perl -w          

=pod
 Copyright 2004-2011 Luiz C. Mostaço-Guidolin
 
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

require "lib/read_configurations.pl"
require "lib/user_defined/legacy.pl" ;
require "lib/user_defined/experiment.pl" ;

&usage() if( !defined @ARGV || $#ARGV < 1 ) ;

&ReadConfigurations( "etc/general.conf", \%confs );
&ReadConfigurations(
  "etc/$general_confs{DEVICE_1_CONFIGURATION}",
  \%device_1_confs
);
  
my $device1 = $confs{DEVICE_1_PATH} ;

# the channels to acquire as specified by the user
my ( $startCH , $endCH ) ;

if( $ARGV[1] =~ /:/ )
{
  ( $startCH , $endCH ) = split /:/ , $ARGV[1] ;
}
else{ $startCH = $endCH = $ARGV[1] ; }


if( ! defined &setExperimentParameters( $device1 , \%device_1_confs ) )
{
  print "\nWave Form Capture Aborted!\n\n" ;
  exit ;
}

foreach( $startCH .. $endCH )
{
  &WaveFormCapture( $ARGV[0] , "CH$_" ) ;
  &ParseWaveFile( $ARGV[0] , "CH$_" ) ;
}
  
exit ;

