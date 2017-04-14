# Setup NDT Server on Ubuntu 14.04

##### Server Configuration in OpenStack:
- Comcast Cloud Ubuntu 14.04 x86_64 v2.5
- m1.medium (4GB RAM/2 CPU)
- ndt-group security group
- Ports opened (below):
```
3001	TCP	NDT data
3002	TCP	NDT data
3003	TCP	NDT data
7123	TCP	NDT web interface
```

##### Prereqs:
```
sudo su -
apt-get update
apt-get upgrade
apt-get install libncurses-dev build-essential kernel-package
```

##### Kernel Patching:
- Create shell script to setup basics as shown below, as install.sh (`chmod +x install.sh` and then `./install.sh` to run the script)
```
#!/bin/bash
cd /usr/src

wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.1.tar.bz2

wget https://www.web10g.org/images/Software/Web10G_Kernel_Patches/web10g-estats-0.1-3.4.tar.gz

wget https://www.web10g.org/images/Software/Web10G_Kernel_Patch_and_API_Packages/Web10g-userland-2.0.8.tar.gz

wget http://software.internet2.edu/sources/ndt/ndt-3.7.0.2.tar.gz

tar xjvf linux-3.4.1.tar.bz2

tar xzvf web10g-estats-0.1-3.4.tar.gz 
tar xzvf Web10g-userland-2.0.8.tar.gz 
tar xzvf ndt-3.7.0.2.tar.gz

rm *.tar.*

mv web10g-estats-0.1-3.4 /usr/src/linux/

ln -s linux-3.4.1 linux

cd /usr/src/linux

bzip2 web10g-estats-0.1-3.4/estats-nl-0.1-3.4.patch
```
- Run below command to have a dry run patch to see if it patches without errors
`bzip2 -dc /usr/src/linux/web10g-estats-0.1-3.4/estats-nl-0.1-3.4.patch.bz2 | patch -p1 --dry-run`

- Run `bzip2 -dc /usr/src/linux/web10g-estats-0.1-3.4/estats-nl-0.1-3.4.patch.bz2 | patch -p1` to patch the kernel.

**Make backup of current kernel config:**
- `cp /boot/config-{uname -r} ./.config`

**Activate patch:**
- `make menuconfig`
- Configure the kernel with the TCP Extended Statistics enabled:
```
Networking support --> 
    Networking options -->
      TCP:Extended TCP statistics (TCP ESTATS) MIB = <*>
```
- Additionally, enable the NetLink ABI:
```
  Networking support --> 
    Networking options -->
      TCP:Extended TCP statistics (TCP ESTATS) MIB
        TCP: ESTATS netlink module (NEW) = <M>
```
**Issue the following command to not only compile your new kernel, but to also create .deb packages that you can use to install the web10g patched kernel on other Ubuntu systems (or keep as backups), so you can skip this step the next time:**
```
make-kpg clean
fakeroot make-kpkg --initrd --apend-to-version=-web10g kernel_image kernel_headers
(Note this will take a LONG time)
```

**See if the .deb package for kernel_headers and kernel_image is now present:**
```
cd /usr/src
ls -l
```
**Install image and headers:**
```
dpkg -i linux-image
dpkg -i linux-headers
```

**Restart the system:**
`shutdown -r now`

**Check the kernel version:**
`uname -r`
