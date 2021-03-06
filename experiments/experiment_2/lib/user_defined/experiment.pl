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
  use Math::GSL::RNG;
  use Math::GSL::Randist qw/:all/;

  my $rng = Math::GSL::RNG->new();
  my ( $PHconfs, $dev1, $PHreadings1, $dev2, $PHreadings2 ) = @_;
  my $reading = undef;
  my $reading_num = 0;
  
  while( $reading_num < $PHconfs->{READINGS_PER_POINT} )
  {
    $dev1->Write( "ACQ:STATE STOP" );
    $dev1->Write( "MEASU:IMM:SOU CH1" );
    $dev1->Write( "MEASU:IMM:TYP FREQ" );

    # repeats the acquisition if there was timming error
    do { $reading = $dev1->Write("MEASU:IMM:VAL?"); } until $reading ne "";
    
    $PHreadings1->{CH1_Freq}->set( [$reading_num], [$reading] );
    print "$reading\t";
    
    $dev1->Write( "MEASU:IMM:TYP PK2pk" );

    do { $reading = $dev1->Write("MEASU:IMM:VAL?"); } until $reading ne "";

    $PHreadings1->{CH1_Pk2Pk}->set( [$reading_num], [$reading] );
    print "$reading\t";
    
    
    
    $dev2->Write( "MEASU:IMM:SOU CH1" );
    $dev2->Write( "MEASU:IMM:TYP FREQ" );

    do { $reading = $dev2->Write("MEASU:IMM:VAL?"); } until $reading ne "";

    $PHreadings2->{CH1_Freq}->set( [$reading_num], [$reading] );
    print "$reading\t";

    $dev2->Write( "MEASU:IMM:TYP PK2pk" );

    do { $reading = $dev2->Write( "MEASU:IMM:VAL?"); } until $reading ne "";
    
    $PHreadings2->{CH1_Pk2Pk}->set( [$reading_num], [$reading] );
    print "$reading\n";

    $dev2->Write( "ACQ:STATE run" );

    # holds the execution of the next step by an pseudo-aleatory period of
    # time in the range of 0 to 1 second.
    select( undef , undef , undef , gsl_ran_flat( $rng->raw(), 0.0, 1.0 ) );

    $reading_num++;
  }
}

1;
