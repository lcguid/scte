##______________________________________________________________________________ 
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

=pod __________________________________________________________________________
 InitializeStorage - create the directories and files where the raw and 
          pre-analised data will be stored based on the information supplied by
          the operator;
   - receive: (1st arg) pointer to hash containing configuration parameters
              (2nd arg) pointer to hash containing experiment information
              supplied by the operator;
              (3rd arg) pointer to hash for file descriptors
   - return : nothing.
=cut #_________________________________________________________________________
sub InitializeStorage
{
  my ( $PHgeneral_confs, $PHfiles ) = @_;

  use POSIX qw(strftime);
  my $date = strftime "%Y%m%d-%H%M" , localtime;
  my $analysed_file_name = undef; 

  # generate output file names
  my $file_name = "$date-$PHgeneral_confs->{DEV_ID_UNDER_CAL}-" .
                  "output_$PHgeneral_confs->{OUTPUT_UNDER_CAL}-" . 
                  "freq_$PHgeneral_confs->{FREQ_CAL}";

  # determine the work directory (where the files will be stored).   
  my $work_dir = 
    "$PHgeneral_confs->{OUTPUT_DIR}/$PHgeneral_confs->{DEV_ID_UNDER_CAL}";

  # determine the file name of the pre-analysed data
  $PHfiles->{ANALYSED} = "${work_dir}/${file_name}.dat";

  #determine the file name of the non analysed data (raw data)
  $PHfiles->{RAW_DATA} = "${work_dir}/rawdata/${file_name}.raw";
  
  if( ! -d $PHgeneral_confs->{OUTPUT_DIR} )
  {
    mkdir( $PHgeneral_confs->{OUTPUT_DIR} ) or 
    die "\n\n InitializeStorage() mkdir [$PHgeneral_confs->{OUTPUT_DIR}]:$!\n\n";
  }
  
  if( ! -d $work_dir )
  {
    mkdir( "$work_dir" ) or
    die "\n\n InitializeStorage() mkdir [$work_dir]:$!\n\n";
  }
  
  if( ! -d "$work_dir/rawdata" ) 
  {
    mkdir( "$work_dir/rawdata" ) or 
    die "\n\n InitializeStorage() mkdir [$work_dir/rawdata]:$!\n\n";
  }

  rename( $PHfiles->{ANALYSED}, "$PHfiles->{ANALYSED}.old" ) or 
    die "\n\n[$PHfiles->{ANALYSED}]: $!\n\n" if( -f $PHfiles->{ANALYSED} );

  rename( $PHfiles->{RAW_DATA}, "$PHfiles->{RAW_DATA}.old" ) or 
    die "\n\n[$PHfiles->{RAW_DATA}]: $!\n\n" if( -f $PHfiles->{RAW_DATA} );
  
  $analysed_file_name = $PHfiles->{ANALYSED};

  foreach( keys %$PHfiles )
  {
    open $PHfiles->{$_}, ">$PHfiles->{$_}" or 
      die "\n\n[$PHfiles->{$_}]:$!\n\n";
  }

  return $analysed_file_name;
}


=pod __________________________________________________________________________
  CloseStorage - close all file descriptors
    - receive: pointer to hash of file descriptors
    - return : nothing
=cut #_________________________________________________________________________
sub CloseStorage
{
  my $PHfiles = shift;

  foreach( keys %$PHfiles ) { close $PHfiles->{$_}; }
}

=pod __________________________________________________________________________
  WriteFileHeaders - write header to the output files
    - receive: (1st arg) pointer to the hash containing the file names
    - return : nothing
=cut #_________________________________________________________________________
sub WriteFileHeaders
{
  my ( $PHfiles ) = @_;

  select $PHfiles->{ANALYSED};

  print "#" . "_" x 46 . "\n#\n";
  print "# COL1 = Channel_TypeOfMeasurement\n";
  print "# COL2 = Mean value\n";
  print "# COL3 = Standard Error\n";
  print "#" . "_" x 46 . "\n";

  select $PHfiles->{RAW_DATA};  

  print "#" . "_" x 46 . "\n#\n";
  print "# COL1 =  Channel_TypeOfMeasurement\n";
  print "# COL2 .. COLN = measurements\n";
  print "#" . "_" x 46 . "\n";

  select STDOUT;
}

=pod __________________________________________________________________________
  WriteData - wirte data to the output files 
    - receive: (1st arg) pointer to hash of file descriptors 
               (2nd arg) pointer to hash of readings
               (3rd arg) pointer to hash of readings averages
               (4th arg) pointer to hash of readings standard errors
    - return : nothing
=cut #_________________________________________________________________________
sub WriteData
{
  my (
    $PHfiles,
    $PHreadings,
    $PHreadings_avg,
    $PHreadings_sderr
  ) = @_;

  my @keys = ( 
    "CH1_Freq",
    "CH1_Pk2Pk",
    "CH2_Freq",
    "CH2_Pk2Pk"
  );

  select $PHfiles->{RAW_DATA};

  foreach( @keys )
  {
    print "$_";
    foreach( $PHreadings->{$_}->as_list ) { print ":$_" }
    print "\n";
  }

  select $PHfiles->{ANALYSED};

  foreach( @keys )
  {
    print "$PHreadings_avg->{$_}\t$PHreadings_sderr->{$_}\t";
  }

  print "\n";
  
  select STDOUT;
}


1;
