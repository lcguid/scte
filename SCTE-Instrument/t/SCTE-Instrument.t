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

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SCTE-Instrument.t'

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 8;

BEGIN { use_ok('SCTE::Instrument') };
require_ok( 'Device::SerialPort' );
require_ok( 'Term::ANSIColor' );

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $instrument = SCTE::Instrument->new();

isa_ok( $instrument, 'SCTE::Instrument', "Instrument object created" );

$instrument->SetBUS( 'USB' );
is( $instrument->GetBUS(), 'USB', "USB BUS set and acquired" );

$instrument->SetBUS( 'RS-232' );
is( $instrument->GetBUS(), 'RS-232', "RS-232 BUS set and acquired" );

is( $instrument->GetDelay(), 0.5, "Default delay = 0.5" );
$instrument->SetDelay( 0.8 );
is( $instrument->GetDelay(), 0.8, "Default delay set to 0.8" );


