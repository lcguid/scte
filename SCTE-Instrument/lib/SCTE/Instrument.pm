#  Copyright 2004-2011 Luiz C. Mostaço-Guidolin
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

package SCTE::Instrument;

use 5.008000;
use strict;
use warnings;

use Term::ANSIColor qw(:constants);

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration use SCTE::Instrument ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '3.0.0';

$Term::ANSIColor::AUTORESET = 1;

###############################################
# SCTE::Instrument implementation begins here #
##############################################

sub new
{
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = {};
    
  $self->{BUS} = undef;
  $self->{CONFIGURATIONS} = undef;
  $self->{DEVICE} = undef;
  $self->{PEER_ADDRESS} = undef;
  $self->{PEER_PORT} = 5025;
  $self->{DELAY} = 0.5;
  
  bless( $self, $class );
  
  return $self;
}

=pod
  SetDevice - set the device path
    - receive: path to the device file
    - return : $self->{DEVICE}
=cut
sub SetDevice
{
  my $self = shift;
  my $dev = undef;
  
  if( @_ ) { $dev = shift; }
  else { die "ERROR [SetDevice( DEVICE )]: no DEVICE specified!"; }
  
  if( $dev ~= /\\dev\\/ )
  {
    if( ! -r $dev or ! -w $dev )
    {
      die "ERROR [SetDevice( path )]: '$dev' should be readable and writable by user";
    }

    if( ! -c $dev )
    {
      die "ERROR [SetDevice( path ) ]: '$dev' should be a character device";
    }
  }
  # else
  # {
  #   # Should I test something here ?!
  # }
  
  $self->{DEVICE} = $dev;
  
  return $self->{DEVICE};
}

sub GetDevice
{
  my $self = shift;
  
  return $self->{DEVICE};
}

=pod
  SetBUS() - set BUS type of the instrument
    - receive: string, RS-232 or USB
    - return : $self->{BUS}
=cut
sub SetBUS
{
  my $self = shift;
  my $bus = undef;
  
  if( @_ ) { $bus = shift; }
  else { die "ERROR [SetBus( BUS )]: no BUS specified!"; }
  
  if( $bus !~ /(^RS-232$|^USB$|^LAN$)/ )
  {
    die "ERROR [SetBUS( bus )]: bus should be one of 'RS-232' | 'USB' | 'LAN'";
  }
  
  $self->{BUS} = $bus;
  
  return $self->{BUS};
}

sub GetBUS
{
  my $self = shift;
  
  return $self->{BUS};
}

=pod
  SetDelay - set the amount of delay between sending a command to the device and
             reading its response
    - receive: a double corresponding to the amount of delay in seconds
    - return : $self->{DELAY}
=cut
sub SetDelay
{
  my $self = shift;
  my $delay = undef;
  
  if( @_ ) { $delay = shift; }
  else { die "ERROR [SetDelay( DELAY )]: no DELAY specified!"; }
  
  $self->{DELAY} = $delay;
  
  return $self->{DELAY};
}

sub GetDelay
{
  my $self = shift;
  
  return $self->{DELAY};
}

=pod
  SetPeerAddress() - set the network address of the instrument
    - receive: IP address of hostname
    - return : $self->{PEER_ADDRESS}
=cut
sub SetPeerAddress
{
  my $self = shift;
  my $addr = undef;
  
  if( @_ ) { $addr = shift; }
  else { die "ERROR [SetPeerAddress( ADDRESS )]: no network ADDRESS specified!"; }
  
  $self->{PEER_ADDRESS} = $addr;
  
  return $self->{PEER_ADDRESS};
}

sub GetPeerAddress
{
  my $self = shift;
  
  return $self->{PEER_ADDRESS};
}

=pod
  SetPeerPortNum() - set the network port number of the instrument
    - receive: port number
    - return : $self->{PEER_PORT}
=cut
sub SetPeerPortNum
{
  my $self = shift;
  my $port_num = undef;
  
  if( @_ ) { $port_num = shift; }
  else { die "ERROR [SetPeerPortNum( PORT )]: no network PORT NUMBER specified!"; }
  
  $self->{PEER_PORT} = $port_num;
  
  return $self->{PEER_PORT};
}

sub GetPeerPortNum
{
  my $self = shift;
  
  return $self->{PEER_PORT};
}


=pod
  SetConfiguration() - load the configuration parameters to the device object
    - receive: pointer to a hash containing the SCPI command as key and value
               to be set as value of the hash
    - return : nothing
    - example:
    
    my %params = (
      "ACQ:MOD"    => "SAM",  # ACQUIRE -> MODE = SAMPLE
      "ACQ:NUMAV"  => "128",  # ACQUIRE -> AVERAGE NUMBER = 128
    );
    
    $device->SetConfigurations( \%params );
=cut
sub SetConfigurations
{
  my $self = shift;
  
  if( @_ ) { $self->{CONFIGURATIONS} = shift; }
  else 
  {
    die "ERROR [SetConfigurations( PHconfs )]: no pointer \
        to hash of configurations provided!"; 
  }
  
  return $self->{CONFIGURATIONS}
}

=pod
  Configure - send configuration parameters to the device
=cut
sub Configure
{
  my $self = shift;

  foreach( sort keys %{ $self->{CONFIGURATIONS} } )
  {
    $self->Write( "$_ $self->{CONFIGURATIONS}{$_}" );
  }
}

=pod
  CheckConfigurations() - queries the device for its configuration parameters and
            prints to STDOUT the read parameters and the default parameters.
    - receive: nothing
    -  return: nothing
=cut
sub CheckConfigurations
{
  my $self = shift;
  
  #$self->PrintTitle();
  print BOLD BLUE "Checking Instrument Configuration:\n" . "_" x 70 . "\n\n";
  print BOLD YELLOW "    * ";
  print RED "BUS";
  print YELLOW "."x(25 - length("BUS"));
  print BOLD GREEN $self->{BUS} . "\n";
  print BOLD YELLOW "    * ";
  print RED "DEVICE";
  print YELLOW "."x(25 - length("DEVICE"));
  print BOLD GREEN $self->{DEVICE} . "\n";
  print BOLD YELLOW "    * ";
  print RED "DELAY";
  print YELLOW "."x(25 - length("DELAY"));
  print BOLD GREEN $self->{DELAY} . "\n";
  
  foreach( sort keys %{ $self->{CONFIGURATIONS} } )
  {
    my $command = $_;
    print BOLD YELLOW "    * ";
    print RED "$command";
    print YELLOW "."x(25 - length($command));

    my $reply = $self->Write( "${command}?" );

    if( ! $reply ) { print BOLD RED " [FAILED]"; }
    else { print BOLD GREEN $reply; }

    print GREEN " ($self->{CONFIGURATIONS}{$command})\n";
  }
  
  print BOLD BLUE "_" x 70 . "\n";
}

=pod
  Write() - send messages to the device
    - receive: (1st arg) the message to be sent to the device;
    - return : the response to the message sent to the instrument
=cut
sub Write
{
  my $self = shift;
  my $message = undef;
  my $reply = undef;
  
  if( @_ ) { $message = shift; }
  else { die "ERROR [Write( MESSAGE )]: no MESSAGE specified!"; }

  
  if( ! $self->{DEVICE} )
  {
    die "ERROR [Write()]: you have to SetDevice() first !";
  }
  
  if( ! $message )
  {
    die "ERROR [Write( msg )]: needs a message !";
  }

  $reply = $self->LANWrite( $message ) if( $self->{BUS} =~ /^LAN$/ );  
  $reply = $self->SerialWrite( $message ) if( $self->{BUS} =~ /^RS-232$/ );
  $reply = $self->USBWrite( $message ) if( $self->{BUS} =~ /^USB$/ );

  
  return $reply;
}

=pod
  SerialWrite() - send a command to the device connected to the serial port and 
                  reads its response.
    - receive: (1st arg) the command to be sent to the equipment;
    - return : the content of the reply given by the equipment;
=cut
sub SerialWrite
{
   my $self = shift;
   my $command = undef;
   my $answer = undef;

   if( @_ ) { $command = shift; }
   else { die "ERROR [SerialWrite( MESSAGE )]: no MESSAGE specified!"; }
    
  use Device::SerialPort;

  # Initialization of the serial port
  my $dh = Device::SerialPort->new( $self->{DEVICE} );
  
  die "Can't open serial device $self->{DEVICE}: $^E\n" unless( $dh );
  
  $dh->write( "$command\n" );

  select( undef , undef , undef , $self->{DELAY} );

  chomp( $answer = $dh->input );
    
  undef $dh;
  return $answer;
}


=pod
  LANWrite() - send a command to the device connected via ethernet and 
               reads its response.
    - receive: (1st arg) the command to be sent to the equipment;
    - return : the content of the reply given by the equipment;
=cut
sub LANWrite
{
   my $self = shift;
   my $command = undef;
   my $answer = undef;

   if( @_ ) { $command = shift; }
   else { die "ERROR [SerialWrite( MESSAGE )]: no MESSAGE specified!"; }
    
  use IO::Socket;

  # Initialize the socket
  my $sock = new IO::Socket::INET(
    PeerAddr => $self->{PEER_ADDRESS},
    PeerPort => $self->{PEER_PORT},  
    Proto => 'tcp'
  );

  die "Socket Could not be created, Reason: $!\n" unless $sock;
  
  print $sock "$command\n";

  select( undef , undef , undef , $self->{DELAY} );

  $answer = <$sock>;
  chomp( $answer );
  
  $socket->close();
  
  return $answer;
}

=pod
  SerialWriteBuffered() - send a command to the device connected to the serial 
                  port and reads its response and keep read until timeout is 
                  reached.
    - receive: the command (that returns more tha 255 chars as response) 
               to be sent to the equipment;
    - return : the content of the reply given by the equipment;
=cut
sub SerialWriteBuffered
{
  my $self = shift;
  my ( $command ) = @_;
  
  my $STALL_DEFAULT = 10; # how many seconds to wait for new input
  my $timeout = $STALL_DEFAULT;
  my $buffer = "";

  use Device::SerialPort;

  # Initialization of the serial port
  my $dh = Device::SerialPort->new( $self->{DEVICE} );
  die "Can't open serial device $self->{DEVICE}: $^E\n" unless( $dh );
   
  $dh->read_char_time(0);    # don't wait for each character
  $dh->read_const_time(100); # 1 second per unfulfilled "read" call
  
  print MAGENTA "\nREADING BUFFER:";
  
  $dh->write( $command );
  print $dh->input();
  
  select( undef , undef , undef , $self->{DELAY} );
  
  my $stdout_flush = select( STDOUT );
  $| = 1;
  select( $stdout_flush );
  
  while( $timeout > 0 )
  { # it will read _up to_ 255 chars at a time
    my ( $count, $saw ) = $dh->read( 255 ); 
  
    if( $count > 0 )
    {
      $buffer .= $saw;
      print MAGENTA "."; 
    }
    else { $timeout--; }
  }
  
  if( $buffer !~ "" ) { print BOLD BLUE " [DONE]"; }
  else { print BOLD RED " [FAILED]"; }

  return $buffer;
}


=pod
  USBWrite() - send a command to the device connected to the serial port and 
                  reads its response.
    - receive: (1st arg) the command to be sent to the equipment;
    - return : the content of the reply given by the equipment;
=cut
sub USBWrite
{
  my $self = shift;
  my $command = undef;
  my $answer = undef;

  if( @_ ) { $command = shift; }
  else { die "ERROR [USBWrite( MESSAGE )]: no MESSAGE specified!"; }

  open DH, "+<", $self->{DEVICE} or 
    die "Can't open USB device $self->{DEVICE}: $^E\n";

  print DH "$command\n";

  select( undef , undef , undef , $self->{DELAY} );

  while( <DH> )
  {
    $answer = $_;
  }
  
  close DH;

  return $answer;
}

=pod 
 PrintTitle() - print the name and version of this application to STDOUT
  - receive: nothing
  - return : nothing
=cut
sub PrintTitle
{
  system( "clear" );
  print BOLD WHITE " " x 10 . "SCTE - Software for Controlling Testing Equipments";
  print WHITE "\n" . " " x 26 . "Version $VERSION\n\n";
}

###############################################
#  SCTE::Instrument implementation ends here  #
###############################################

1;
__END__


# SCTE Documentation

=head1 NAME

SCTE::Instrument - Perl extension for blah blah blah

=head1 SYNOPSIS

  use SCTE::Instrument;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for SCTE::Instrument, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Luiz Guidolin, E<lt>lcguid@wp.shawcable.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Luiz Guidolin

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
