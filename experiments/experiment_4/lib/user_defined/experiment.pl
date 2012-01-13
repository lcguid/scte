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

sub RunExperiment
{
  my ( $dev, $PSreadings ) = @_;
  
  # If there is another printing process running it, then we stop it
  $dev->Write( "HARDCopy ABOrt" );
  
  # start capturing image data
  # ${$PSreadings} = $dev->SerialWriteBuffered("HARDCopy STARt\n") ;
  ${$PSreadings} = $dev->Write("HARDCopy STARt") ;
}

1;
