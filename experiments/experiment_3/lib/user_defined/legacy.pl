#  Copyright 2004-2011 Luiz Carlos Büttner Mostaço-Guidolin
#  
#  This file is part of SCTE.
#
#  SCTE is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  SCTE is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with SCTE. If not, see <http://www.gnu.org/licenses/>.

use Term::ANSIColor qw(:constants);
  $Term::ANSIColor::AUTORESET = 1;

=pod
* setExperimentParameters() *
 purpose: send to the equipment all the necessary parameters that has to be set
           before the beginning of the experiment;
 receive: (1st arg) device name (path) for the port the equipment is connected 
          to (2nd arg) a pointer to the hash containing the parameters to be 
          set.
          The keys of this hash must be a valid SCPI command and the key the
          value to be set with that command.
=cut
sub setExperimentParameters
{
  my ( $dev , $PHparameters ) = @_;

  print BOLD BLUE "\n\nSetting Experiment Parameters:\n" . "=" x 70 . "\n";

  # Stops printing the header of each command
  &SerialWrite( $dev, "HEADer off" ); 

  foreach( sort keys %$PHparameters )
  {
    print BOLD YELLOW "\t* ";
    print RED "$_";
    print YELLOW "."x(25 - length($_));
    &SerialWrite( $dev , "$_ $PHparameters->{$_}" );
    print BOLD GREEN &SerialWrite( $dev, "$_?" );
    print GREEN " ($PHparameters->{$_})\n";
  }
  print BOLD BLUE "=" x 70 . "\n";
  
  return &ShallIGoOn();
}

=pod
* SerialWrite() *
 purpose: send a command to the device connected to the serial port and 
          reads its response.
 receive: (1nd arg) the command to be sent to the equipment;
          (2rd arg) a period of time to wait before reading the equipment
                     answer;
  return: the content of the answer given by the equipment;
=cut
sub SerialWrite
{
  my ( $dev , $command , $wait ) = @_; 
  my $answer;
    
    use Device::SerialPort;

    # Initialization of the serial port
  $dh = Device::SerialPort->new( $dev );
   
    die "Can't open serial device $dev: $^E\n" unless( $dh );
  
  $dh->write( "$command\n" );

  $wait = 0.5 unless defined $wait;
  select( undef , undef , undef , $wait );

  chomp( $answer = $dh->input );
    
    undef $dh;
    return $answer;
}

1;
