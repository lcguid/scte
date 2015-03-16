# SCTE - Software for Controlling Testing Equipment #


---


**SCTE**  is a framework written in Perl that has been designed to automate data acquisition and equipment control
in experimental Physics and Engineering. It's capable of controlling devices via RS-232 (serial), USB, and Ehternet (LAN) ports using the _Standard Commands for Programmable Instruments_ (**SCPI**).

For the USB interface, the _USB  Test & Measurement Class_ implemented as the `usbtmc.ko` Linux kernel module is used. The RS-232 communication rely on the `Device::SerialPort` perl module available from CPAN.


---


**For installation and usage instructions visit our [Wiki](http://code.google.com/p/scte/w/list).**


---


**NOTE:** The current kernel USBTMC module is not working, in order to use SCTE with USB instruments you must use the USBTMC module provided by Agilent (see [Wiki::USBTMC](http://code.google.com/p/scte/wiki/USBTMC))


---

**NEWS:** The full paper on SCTE has been published by **Computer Physics Communications** (see [here](http://dx.doi.org/10.1016/j.cpc.2012.02.013))

---


