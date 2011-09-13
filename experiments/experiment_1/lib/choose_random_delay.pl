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
  ChooseRandomDealay() - read /dev/urandom for pseudo-aleatory number generation
    - receive: nothing
    - return : 0.5, if /dev/urandom is not readable
               [0:1], otherwise
=cut
sub ChooseRandomDelay
{
  return 0.5 if ! -r "/dev/urandom";
  my ( $rand1 , $rand2 , $ascii1 , $ascii2 );

  open RAND , "</dev/urandom" or die "[/dev/urandom]:$!";
  read RAND , $rand1 , 1;
  read RAND , $rand2 , 1;
  read RAND , $rand2 , 1 while $rand2 eq $rand1;
  close RAND;

  $ascii1 = unpack( "C" , $rand1 );
  $ascii2 = unpack( "C" , $rand2 );

  return abs( sin( (-1)**$ascii1 * $ascii2 ));
}

1;
