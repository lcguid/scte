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

sub AnalyseReadings
{
  my ( $PSreadings, $PSchannel, $PHscale_factors ) = @_;
  my @data;
  my $x;
  my $y;

  open FILEin , "/tmp/${inDataFile}_scte.tmp" or die $!;
    @data = <FILEin>;
  close FILEin;
  
  open FILEout , ">$ENV{PWD}/${inDataFile}_${channel}.dat" or die $!;
  
  @data = split /,/ , $data[1];

  foreach( 0 .. $#data )
  {   
    $x = $PHscale_factors->{"WFMPre:${channel}:XZEro"} + 
         $PHscale_factors->{"WFMPre:${channel}:XINcr"} * 
         ( $_ - $PHscale_factors->{"WFMPre:${channel}:PT_OFf"} );
    $y = $PHscale_factors->{"WFMPre:${channel}:YZEro"} + 
         $PHscale_factors->{"WFMPre:${channel}:YMUlt"} * 
         ( $data[$_] - $PHscale_factors->{"WFMPre:${channel}:YOFf"} );

    print FILEout $x . "\t" . $y . "\n";
  }
  
  close FILEout;
}

1;
