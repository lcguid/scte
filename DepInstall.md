# Introduction #

SCTE has been tested in Ubuntu 11.04, running kernel 2.6.38-11, and the following specific steps for installing all necessary dependencies should work in any Debina/Ubuntu distribution, although some package names may vary.

## Installing Required Packages ##

In a terminal, run:

```
sudo apt-get install liberror-perl libextutils-pkgconfig-perl libyaml-perl libyaml-syck-perl pkg-config libgsl0-dev
```

with all necessary packages installed, proceed with installation of the required Perl modules!

## Installing Required Perl Modules ##

To install the required modules you must enter the CPAN shell:

```
sudo perl -MCPAN -e shell
```

Then inside the CPAN shell issue the following commands:

```
install Device::SerialPort
install Term::AnsiColor
install Math::GSL
```

If any of these packages require other packages as dependencies a message asking for permission to install will be issued, you just have to say **yes** to all of them.

If everything went well, you should be ready to install SCTE::Instrument and have fun. (see [this link](http://code.google.com/p/scte/wiki/Installation))