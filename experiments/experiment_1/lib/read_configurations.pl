=pod
Copyright 2004-2011 Luiz C. Mostaço-Guidolin

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=cut

=pod
  ReadConfigurations() - read a configuration file into a hash
    - receive: (1st arg) the path for the configuration file
               (2nd arg) a poiter to the hash where the configuration
                         parameters are to be stored;
    - return : nothing it just stores the read parameters into the hash.
    - format : all lines starting with '#' or new line are ignored;
               valid lines are comprised of KEY=value
  
=cut
sub ReadConfigurations
{
  my ( $confs_path , $PHconfs ) = @_;

  open CONFS , $confs_path or die "[$confs_path]: $!";

  while( <CONFS> )
  {
    next if $_ =~ /^\#/ or /^\n/;
    my ( $key , $value ) =  split( /=/ , $_ );
    chomp( $key , $value );
    $PHconfs->{$key} = $value;
  }

  close CONFS;
}

1;