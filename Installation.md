# What is it? #

> SCTE::Instrument is the Perl module, part of the SCTE bundle, and provides an interface to testing instruments connected through serial (RS-232), USB, or Ethernet (LAN) ports.


# Dependencies #


> SCTE::Instrument requires the following modules in order to install and work:

  * Term::ANSIColor => 2.02
  * Device::SerialPort => 1.04
  * Net::HTTP => 5.834

> You can install these modules directly from CPAN ([1](http://www.cpan.org/)). For instructions on how to install Perl modules like these, see http://www.cpan.org/modules/INSTALL.html.

> (1) CPAN - Comprehensive Perl Archive Network. http://www.cpan.org/


# Installation #

> SCTE::Instruments depends on other two libraries that must be present prior the installation (see Dependencies section for more details).

> After installing all the dependencies, you can install this module by typing the following commands in a terminal:

```
     perl Makefile.PL
     make
     make test
     make install
```

  * **NOTE:** in order to install this library system wide, you are required to issue the last command (make install) as the root user.


# Documentation #


> The documentation available as of the date of this release is availabl http://arxiv.org/abs/0906.4833. The most up-to-date documentation can be found at http://scte.sf.net or in this wiki.

After installation you can refer to the man page for information on how to use SCTE::Instrument (`man SCTE::Instrument`).


# Known Bugs #


> There are no known bugs at this time, if you find one please report it. It is the only way we can correct it and improve SCTE stability and usability. For reporting bug, see Contacts section.


# Contacts #

> For contacts and bug repots you can send use our [Issues](http://code.google.com/p/scte/issues/list) page.


# Authors and Acknowledgments #


> See [THANKS](http://code.google.com/p/scte/wiki/Overview#Authors_and_Acknowledgments) for details.


# Licensing #

> See [COPYING](http://code.google.com/p/scte/wiki/Overview#Licensing) for details



---

Use the force, read the source !