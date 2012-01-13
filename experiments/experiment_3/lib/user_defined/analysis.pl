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
  my ( $PSreadings, $PHscale_factors ) = @_;
  my @data = split /,/, ${$PSreadings};
  my $answer = "";
  my $x;
  my $y;

  foreach( 0 .. $#data )
  {
    $x = $PHscale_factors->{"WFMPre:XZEro"} + 
         $PHscale_factors->{"WFMPre:XINcr"} * 
         ( $_ - $PHscale_factors->{"WFMPre:PT_OFf"} );
         
         
    print      $PHscale_factors->{"WFMPre:XZEro"} + 
              $PHscale_factors->{"WFMPre:XINcr"} * 
              ( $_ - $PHscale_factors->{"WFMPre:PT_OFf"} );
         
    $y = $PHscale_factors->{"WFMPre:YZEro"} + 
         $PHscale_factors->{"WFMPre:YMUlt"} * 
         ( $data[$_] - $PHscale_factors->{"WFMPre:YOFf"} );

    # print $x . "\t" . $y . "\n";
    $answer .= $x . "\t" . $y . "\n";
  }
  
  ${$PSreadings} = $answer;
}

1;
