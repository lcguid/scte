# What is it? #

SCTE is a bundle of Perl scripts and a library, that aims to be a simple, yet
powerful, data aquisition system. It is designed to control instruments, such
as oscilloscopes and signal generators, that use the SCPI programming
language ([1](http://www.ivifoundation.org/scpi/default.aspx)) for communication, and are interfaced through the USB, and
RS-232 (serial) ports.

> (1) SCPI - Standard Commands for Programmable Instruments http://www.ivifoundation.org/scpi/default.aspx


# The Latest Version #


> Details of the latest version can be found on the project page under http://scte.sf.net/


# Documentation #

> The documentation available as of the date of this release is available
> http://http://arxiv.org/abs/0906.4833. The most up-to-date documentation can
> be found in this wiki or http://scte.sf.net.


# SCTE Components #

> SCTE is comprised of two parts: SCTE-Instrument, and experiments.

  * 'SCTE-Instrument' is a Perl module that controls and interfaces instruments via USB or RS-232 ports. It requires installation and is necessary in order to run the 'experiments'.

  * 'experiments' is a directory containing two experiment examples (sub-directories experiment\_1 and experiment\_2) on how to use SCTE-Instrument and develop a data acquisition system. The 'experiment\_1' example, controls one oscilloscope connected via USB. The 'experiment\_2', controls two instruments, one connected via USB and the other connected via RS-232. For details about each experiment, refer to the README files under each experiment directory, and consult the documentation (see Documentations section).


# Installation #

SCTE-Instrument requires installation, please see the file called INSTALL under 'SCTE-Instrument' directory or the web version [here](http://code.google.com/p/scte/wiki/Installation).

The companion experiment scripts don't require installation, and can be run directly, considering that it's dependencies have been met. Please see the README file under 'experiments' directory, or the web version [here](http://code.google.com/p/scte/wiki/Experiments).


# Known Bugs #

> There are no known bugs at this time, if you find one please report it. It is
> the only way we can correct it and improve SCTE stability and usability. For
> reporting bug, see Contacts section.


# Contacts #

> For contacts and bug repots you can  use our [Issues](http://code.google.com/p/scte/issues/list) page.


# Authors and Acknowledgments #

> SCTE was originally developed by Luiz C. Mostaço-Guidolin, and have benefitted from massive contributions Rafael B. Frigori. It wouldn't be possible to exist without helpful insights from Roberto L. Parra, Heitor H. Federico, and Diogo B. Tridapalli. Last but not least, this application couldn't definitely exist without the tons of manuals, how to's, tutorials, and all related material made available by the Free and Open Source community.



# Licensing #

> SCTE bundle is free software; you can redistribute it and/or modify it under
> the terms of the GNU General Public License as published by the Free Software
> Foundation; either version 3, or (at your option) any later version.

> SCTE bundle is distributed in the hope that it will be useful, but WITHOUT
> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
> details.

> You should have received a copy of the GNU General Public License along with
> SCTE; see the file COPYING.  If not, write to the Free Software Foundation,
> Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.


---

  * **Use the force, read the source !**

---
