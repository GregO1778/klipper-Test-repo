#Intro
This is a fork of the Creality "sonic_pad_os" repo.  I forked this repo for three reasons:
1. Creality has unfortunatly abanded this repo and product in their usual fashin (get it to 90%-95% complete then never make any more updates but still continue to sell the product) so I am attempting to get this repo back up and going so that newer versions of Klipper can be run on the Sonic Pad
2. The repo on Creality's github page can nolonger be built as it is.  Too many of the files cannot be downloaded from the specified locations in teh "MakeFile" and creality has not supplied those files.  I have tracked down all of the files and included them in the "dl" folder so that this project can once again be built without the need to track all of the files down
3. To start the process of updating this repo to a newer version of Klipper (and possibly other files but that will be TBD)

After hours of tracking down files and getting this repo back into shape, I have discovered that this is not something that creality put together from scratch.
That was already somewhat obvius if you look at any of the files but in reality it appears that the only thing Creality has done is create the "Creality" directory in the "Package" folder
and add a few other packages as well.  The majority of this project it tied to a few other repos:
1. https://github.com/openwrt/openwrt (https://github.com/openwrt this repo may be the largest help in getting this project updated)	
2. https://github.com/tinalinux
3. https://xajhuang.com:3100/netease

A couple other repos that may be of assistance but not specificly tied to this project:
1. https://sources.openwrt.org/ https://mirror2.openwrt.org/sources/
2. https://sources.immortalwrt.org/
3. https://www.kernel.org/pub/linux/utils/kernel/
4. https://www.freedesktop.org/wiki/Software/
5. https://ftp.gnu.org/gnu/
6. https://download-mirror.savannah.gnu.org/releases/ https://download.savannah.nongnu.org/releases/
7. https://github.com/linux-sunxi

This is not the only repo needed to get everything up and running from scratch on a Sonic Pad.  You also need the "Sonic Pad Klipper" repo and the "SOnic Pad Firmware" repo which are oddly on differant github pages than the OS
All of these will be brought togther in my repo as I build this out for ease of use.

I am not a developer by trade so if anyone wants to contribue to this I would be very greateful.

# sonic_pad_os
It is recommended to use Ubuntu18.04 to compile sonic_pad_os, and install the related Package dependency:
"sudo apt install git gcc gawk flex libc6:i386 libstdc++6:i386 lib32z1 libncurses5 libncurses5-dev python g++ libz-dev libssl-dev make p7zip-full"

1. Download the code:
   1 git clone https://github.com/CrealityTech/sonic_pad_os.git
2. Enter the root directory of sonic_pad_os
3. create a "dl" folder
   1 mkdir ./sonic_pad_os/dl
   2 NOTE: This repo will include the "dl" directory, most of these notes are from the original repo
4. Download the dl package, save the downloaded dl package in the sonic_pad_os/dl directory.
   1 Download link: https://klipper.cxswyjy.com/download/sonic_dl/
   2 NOTE: This repo will include these files allong with any other needed packages in the "dl" folder already so you do not have to download them seperatly
5. I found that I needed to change the permissions (and the owner in some cases) of the files when I copy thime from a share folder in my VM.  since this is a VM just for this build, I didn't mind
   1 sudo chmod 777 -R ./dl/
   2 sudo chown "YourUserName":"YourUserName" -R ./dl/
6. Create a blank ".lunchrc" file in your user dir (I don't know why this isn't created automaticly but "lunch" will not work without it)
   1 vim ~/.lunchrc
   2 save and exit vim
7. Execute the prep script
   1 ./scripts/prepare.sh
8. Compile steps:
   1 source ./build/envsetup.sh
   2 lunch 6
   3 make -j2 && pack
   4 swupdate_pack_swu -ab
9. U flash drive upgrade method: Copy the config.ini and t800-sonic_lcd-ab_1.0.6.48.57.swu files in the sonic_pad_os/out/r818-sonic_lcd/ directory to the root directory of the U flash drive. The firmware version number must be greater than the current version number of the device, otherwise the upgrade box will not pop up.
10. Computer upgrade method: The image path generated after compilation is sonic_pad_os/out/r818-sonic_lcd/t800-sonic_lcd_uart0.img, please refer to the link for the burning tool and upgrade method: https://github.com/CrealityOfficial/Creality_Sonic_Pad_Firmware



# WIP - Get this working in Ubuntu 24.10

1. get into /etc/apt/sources.list.d and locate ubuntu.sources.
2. sudo vim ./ubuntu.sources
3. add these lines:-
   1. Types: deb
   2. URIs: http://security.ubuntu.com/ubuntu 
   3. Suites: focal-security
   4. Components: main universe
   5. Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
   6. 
   7. Types: deb
   8. URIs: http://security.ubuntu.com/ubuntu 
   9. Suites: bionic-security
   10. Components: main universe
   11. Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
4. sudo add-apt-repository universe
5. sudo apt update
6. wget http://security.ubuntu.com/ubuntu/pool/universe/p/python2.7/python2.7_2.7.18-13ubuntu1.5_amd64.deb http://security.ubuntu.com/ubuntu/pool/universe/p/python2.7/libpython2.7-stdlib_2.7.18-13ubuntu1.5_amd64.deb http://security.ubuntu.com/ubuntu/pool/universe/p/python2.7/python2.7-minimal_2.7.18-13ubuntu1.5_amd64.deb http://security.ubuntu.com/ubuntu/pool/universe/p/python2.7/libpython2.7-minimal_2.7.18-13ubuntu1.5_amd64.deb  
7. sudo apt install ./libpython2.7-minimal_2.7.18-13ubuntu1.5_amd64.deb ./libpython2.7-stdlib_2.7.18-13ubuntu1.5_amd64.deb ./python2.7-minimal_2.7.18-13ubuntu1.5_amd64.deb ./python2.7_2.7.18-13ubuntu1.5_amd64.deb
8. sudo apt install git gcc gawk flex libc6:i386 libstdc++6:i386 lib32z1 libncurses5 libncurses5-dev python g++ libz-dev libssl-dev make p7zip-full vim bzip2 tar

sudo apt install git gcc gawk flex libc6:i386 libstdc++6:i386 lib32z1 libncurses5 libncurses5-dev python g++ libz-dev libssl-dev make p7zip-full bison build-essential flex-doc g++-multilib g++-7-multilib gcc-7-doc libstdc++6-7-dbg gawk-doc gcc-multilib autoconf automake libtool gcc-doc gcc-7-multilib gcc-7-locales libgcc1-dbg libgomp1-dbg libitm1-dbg libatomic1-dbg libasan4-dbg liblsan0-dbg libtsan0-dbg libubsan0-dbg libcilkrts5-dbg libmpx2-dbg libquadmath0-dbg git-daemon-run git-doc git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn glibc-doc:i386 glibc-doc ncurses-doc libssl-doc libstdc++-7-doc m4-doc make-doc p7zip-rar python-doc python-tk python2.7-doc binfmt-support python3 python-lunch vim