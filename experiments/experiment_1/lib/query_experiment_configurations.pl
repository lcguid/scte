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


=pod
  QueryExperimentConfigurations() - description
    - receive:
    - return : 
=cut
sub QueryExperimentConfigurations
{
  my $PHconfs = undef;

  if( @_ ) { $PHconfs = shift; }
  else{ die "ERROR: [RequestExperimentConfigurations( \\%EXPERIMENT_CONF )]:
      \\%EXPERIMENT_CONF not provided!"; }
  

  print BOLD BLUE "\n\nExperiment Information:\n" . "_" x 70 . "\n";

  foreach( sort keys %$PHconfs )
  {
    print RED " -> $PHconfs->{$_}:";
    print RED "."x( 55 - length($PHconfs->{$_} ) );

    chomp( my $stdinAux = <STDIN> );
    $PHconfs->{$_} = $stdinAux;
  }

  print BOLD BLUE "_" x 70 . "\n";
}


# &banana( &amassada() );
#   
# sub banana
# {
#   my $func = shift;
# 
#   $func;
# }
# 
# sub amassada
# {
#     print "\n\nBANANA AMASSADA\n\n";
# }


1;
