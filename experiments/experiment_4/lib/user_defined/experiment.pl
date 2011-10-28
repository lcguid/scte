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
* ScreenCapture() *
 it does: capture the content of the screen of the equipment;
 receive: (1st arg) device name (path) for the port the equipment is 
                    connected to;
          (2nd arg) the file name where the image will be stored;
  return: nothing but the PCX file containing the captured image will 
          be created.
     obs: the equipment must be equipped with the so called HADRCOPY
          functionality.
=cut
sub ScreenCapture
{
  my ( $dev , $file_name ) = @_ ; # output file name
  my $timeout = 10 ; # how many seconds to wait for new input
  my $chars = 0 ;
  my $buffer = "" ;

  use Device::SerialPort ;

  # Initialization of the serial port
  $dh = Device::SerialPort->new( $dev )  ;
    die "Can't open serial device $dev banana: $^E\n" unless( $dh ) ;

  $dh->read_char_time(0);    # don't wait for each character
  $dh->read_const_time(100); # 1 second per unfulfilled "read" call
  
  open FILE , ">$ENV{PWD}/$file_name.pcx" or 
        die "Can't open file for writing: $!" ;
  
  print MAGENTA "\nPROGRESS:" ;

  $dh->write("HARDCopy STARt\n") ;
  
  select( undef , undef , undef , 0.5 ) ;
  my $fh = select(STDOUT) ; $| = 1 ; select($fh) ;

   while( $timeout > 0 )
  {
    my ( $count , $saw ) = $dh->read( 255 ) ; # will read _up to_ 255 chars

    if( $count > 0 )
    {
          $chars += $count ;
            $buffer = $saw ;
      print MAGENTA "." ;  
      print FILE "$buffer" ; # print the buffer content into the output file
        }
        else { $timeout-- ; }
  }

   print BOLD BLUE "\n\nFinished!\n\n" if( $timeout == 0 ); 

  close FILE ;
    undef $dh ;
}

1;
