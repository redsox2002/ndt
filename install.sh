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
