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

format ANALYSIS_STDOUT =
 @<<<<<<<< = @>>>>>>>>>>>>> +- @<<<<<<<<<<<<<
 $_ ,        $avg,             $sderr
.

sub AnalyseReadings 
{
  my ( $PHreadings, $PHreadings_avg, $PHreadings_sderr ) = @_;

  use Math::GSL::Statistics qw /:all/;

  # defines the format for STDOUT
  $~ = "ANALYSIS_STDOUT";

  foreach( sort keys %$PHreadings )
  {
    my @data = $PHreadings->{$_}->as_list;
 
    $PHreadings_avg->{$_} = gsl_stats_mean(
      \@data, 
      1, 
      $PHreadings->{$_}->length
    );
 
    $PHreadings_sderr->{$_} = gsl_stats_sd_m(
      \@data,
      1,
      $PHreadings->{$_}->length,
      $PHreadings_avg->{$_} 
    ) / sqrt( $PHreadings->{$_}->length );

    our $avg = $PHreadings_avg->{$_};
    our $sderr = $PHreadings_sderr->{$_};
    write STDOUT;
  }

}



1;
