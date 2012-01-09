#!/usr/bin/perl -w          

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
* WaveFormCapture() *
 it does: acquire the data used to plot the wave form into the osciloscope's
          screen;
 receive: (1st arg) the prefix of the output file name;
          (2nd arg) the channel of the osciloscope that data must be read;
  return: nothing. It stores a temporary file to be processed by the 
          ParseWaveFile() function.
=cut
sub WaveFormCapture
{
  my ( $file_name , $channel ) = @_;
  my $STALL_DEFAULT = 10; # how many seconds to wait for new input
  my $timeout = $STALL_DEFAULT;
  my $chars = 0;
  my $buffer = "";
  my @command = ( "WFMPre?\n" , "CURVe?\n" ); 

  use Device::SerialPort;

  # Initialization of the serial port
  $dh = Device::SerialPort->new( $dev );
    die "Can't open serial device $dev: $^E\n" unless( $dh );

  $dh->read_char_time(0);    # don't wait for each character
  $dh->read_const_time(100); # 1 second per unfulfilled "read" call
  
  open FILE , ">/tmp/${file_name}_scte.tmp" or die "Can't open file for writing: $!";
  
  print MAGENTA "\nPROGRESS $channel:";
  
  &SerialWrite( "ACQ:STATE STOP" );
  &SerialWrite( "DATa:SOUrce $channel" );

  my $counter = 0;
  while( defined $command[$counter] )
  {
    $dh->write( $command[$counter] );
    print $dh->input();
    
    select( undef , undef , undef , 0.5 );
    my $stdout_flush = select(STDOUT); $| = 1; select($stdout_flush);
    
    while( $timeout > 0 )
    { # it will read _up to_ 255 chars
      my ( $count , $saw ) = $dh->read( 255 ); 
    
      if( $count > 0 )
      {
        $chars += $count;
        $buffer = $saw;
        print MAGENTA "."; 
        print FILE "$buffer";
      }
      else
      {
        $timeout--;
      }
    }
   
    if( $timeout == 0 )
    {
      $counter++;
      $timeout = $STALL_DEFAULT;
      print RED ".";
    }
  }
  print BOLD BLUE "\n\nAcquisition Finished!\n\n";
  close FILE;
}

=pod
* ParseWaveFile() *
 it does: convert the data acquired by the function WaveFormCapture() into
          usable data as descibed in the TDS-100/200 Tektronix Osciloscope's
          programmer manual;
 receive: (1st arg) a file with the data to be processed;
          (2nd arg) the channel of the osciloscope that data was read;
  return: nothing. It stores the file with the usable data points for further
          analysis.
=cut
sub ParseWaveFile
{
  my ( $inDataFile , $channel ) = @_;
  my @data;
  my $x;
  my $y;

  my %scale_factors = (
        "WFMPre:${channel}:XZEro"  => "" ,
        "WFMPre:${channel}:XINcr"  => "" ,
        "WFMPre:${channel}:PT_OFf" => "" ,
        "WFMPre:${channel}:YZEro"  => "" ,
        "WFMPre:${channel}:YMUlt" => "" ,
        "WFMPre:${channel}:YOFf"   => "" 
                      );

  # These are the parameters as described on page 2-180 of the tektronix
  # Osciloscope series TDS-100/200 programmer manual to convert the 
  # acquired data to the usable values.
  foreach( keys %scale_factors )
  {
    $scale_factors{$_} = &SerialWrite( "${_}?" );
    print $_ . " = " . $scale_factors{$_} . "\n";
  }

  open FILEin , "/tmp/${inDataFile}_scte.tmp" or die $!;
    @data = <FILEin>;
  close FILEin;
  
  open FILEout , ">$ENV{PWD}/${inDataFile}_${channel}.dat" or die $!;
  
  @data = split /,/ , $data[1];

  foreach( 0 .. $#data )
  {   
    $x = $scale_factors{"WFMPre:${channel}:XZEro"} + 
         $scale_factors{"WFMPre:${channel}:XINcr"} * 
         ( $_ - $scale_factors{"WFMPre:${channel}:PT_OFf"} );
    $y =  $scale_factors{"WFMPre:${channel}:YZEro"} + 
          $scale_factors{"WFMPre:${channel}:YMUlt"} * 
          ( $data[$_] - $scale_factors{"WFMPre:${channel}:YOFf"} );

    print FILEout $x . "\t" . $y . "\n";
  }
  
  close FILEout;
}

sub usage
{
  print "Usage: WaveFormCapture.pl <shot_number>  x:y\n";
  print "   * shot_number: will be part of the file name\n";
  print "   * x[:y]: are the channel range to capture (from CHx to CHy)\n";
  exit;
}

1;
