use 5.008000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'SCTE::Instrument',
    VERSION_FROM      => 'lib/SCTE/Instrument.pm', # finds $VERSION
    PREREQ_PM         => { 'Term::ANSIColor' => 2.02, 
                           'Device::SerialPort' => 1.04,
                           'Net::HTTP' => 5.834 },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/SCTE/Instrument.pm', # retrieve abstract from module
       AUTHOR         => 'Luiz C. Mostaço-Guidolin <lm.guidolin@gmail.com>') : ()),
);
