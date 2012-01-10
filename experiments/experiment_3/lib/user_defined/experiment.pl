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
  my ( $PHconfs, $dev, $PSreadings, $PSchannel, $PHscale_factors ) = @_;
  
  $PSreading = "";
  
  $dev->Write( "ACQ:STATE STOP" );
  $dev->Write( "DATa:SOUrce $PSchannel" );

  # These are the parameters as described on page 2-180 of the tektronix
  # Osciloscope series TDS-100/200 programmer manual to convert the 
  # acquired data to the usable values.
  foreach( keys %$PHscale_factors )
  {
    $PHscale_factors->{$_} = $dev->Write( "${_}?" );
  }

  $PSreading .= $dev->SerialWriteBuffered( "WFMPre?" );
  $PSreading .= $dev->SerialWriteBuffered( "CURVe?" );  
}

1;
