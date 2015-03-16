# USB Test & Measurement Class #

The USBTMC support under GNU/Linux systems is provided in two ways: native support in the Linux kernel and the legacy USBTMC kernel module developed by [Agilent](http://www.home.agilent.com/upload/cmc_upload/All/usbtmc.html). Since the kernel 2.6.28-11 the native module is not working properly, although we are trying to solve this issue, the best solution for now is to use the module provided by Agilent (download [here](http://www.home.agilent.com/upload/cmc_upload/All/usbtmc.html)). This procedure is supported for kernel 2.6.28-11 only, since tests in newer versions didn't work.

**Note:** a more recent discussion about the USBTMC driver may be found in [this](http://forums.tm.agilent.com/community/viewtopic.php?f=21&t=27493&hilit=usbtmc1&sid=4008e86dd7cdbcbdf2ef1f3ed62bc676) forum, where this driver has been reported to work with newer kernel versions.

# Installation #

The installation is quite simple:

  * download the source code of the module [here](http://www.home.agilent.com/agilent/redirector.jspx?action=ref&lc=eng&cc=CA&nfr=-34952.0.00&ckey=1353201&cname=AGILENT_EDITORIAL)

Create a directory for it:

> ` mkdir usbtmc `

Untar the driver to this directory, enter the directory, and compile the module:

```
tar x usbtmc.tar -C usbtmc
cd usbtmc
make
```

The default kernel module may be loaded, let's unload it and load the recently compiled module:
```
sudo rmmod usbtmc
sudo insmod ./usbtmc.ko
```

If everything went fine, we should be able to create the device files to access the instrument.
```
major=$(grep -i usbtmc | awk '{print $1} ')
sudo mknod /dev/usbtmc0 c $major 0
sudo mknod /dev/usbtmc1 c $major 1
sudo chmod 666 /dev/usbtmc*
```

Once these files are created, we can check if the instrument has been identified:
```
cat /dev/usbtmc0
```

A list with all connected instruments should appear, something like this (where xxxxxxxxx is the serial number of your osciloscope):
```
001 Agilent Technologies DSC1012A xxxxxxxxxx
```

We can finally test the communication with the instrument:
```
echo *IDN? > /dev/usbtmc1
cat /dev/usbtmc1
```

which should return something like this:
```
Agilent Technologies, DSO1012A, xxxxxxxxxx,00.04.06
```

If everything went fine, you should be ready to start using SCTE.

Have fun!