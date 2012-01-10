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
  my ( $PHgeneral_confs, $PSfile ) = @_;

  use POSIX qw(strftime);
  my $date = strftime "%Y%m%d-%H%M" , localtime;

  # generate output file name
  my $file_name = "$date-waveform-CH" . ${$PSchannel} . ".dat";

  # determine the work directory (where the file will be stored).   
  my $work_dir = "$PHgeneral_confs->{OUTPUT_DIR}/";
  
  if( ! -d $work_dir )
  {
    mkdir( $work_dir ) or die "\n\n[$work_dir]:$!\n\n";
  }

  $file_name = $work_dir . $file_name;

  open ${$PSfile}, ">$file_name" or die "\n\n[$file_name]:$!\n\n";
}

sub WriteData
{
  my ( $PSoutput_file, $PSreadings ) = @_;
  
  select ${$PSoutput_file};
  
  print ${$PSreadings};
  
  select STDOUT;
}


=pod __________________________________________________________________________
  CloseStorage - close all file descriptors
    - receive: pointer to hash of file descriptors
    - return : nothing
=cut #_________________________________________________________________________
sub CloseStorage
{
  my $PSfiles = shift;

  close ${$PSfile};
}

1;