#!/bin/sh

echo " "
echo "   ################################################"
echo "   ## Did you execute 1_format_extroot.sh first? ##"
echo "   ################################################"
echo " "
read -p "Press [ENTER] if YES ...or [ctrl+c] to exit"


echo " "
echo "This script will download and install all packages form the internet"
echo " "
echo "   #####################################"
echo "   ## Make sure extroot is enabled... ##"
echo "   #####################################"
echo " "
read -p "Press [ENTER] to check if extroot is enabled ...or [ctrl+c] to exit"

df -h;



echo " "
echo "   ############################################"
echo "   ## Is /dev/mmcblk0p1 mounted on /overlay? ##"
echo "   ############################################"
echo " "
read -p "Press [ENTER] if YES... or [ctrl+c] to exit"

echo " "
echo "   ########################################################"
echo "   ## Make sure you've got a stable Internet connection! ##"
echo "   ########################################################"
echo " "
read -p "Press [ENTER] to Continue ...or [ctrl+c] to exit"

echo " "
echo "#################"
echo "###   SWAP    ###"
echo "#################"
echo " "

echo "Creating swap file"
dd if=/dev/zero of=/overlay/swap.page bs=1M count=512;
echo "Enabling swap file"
mkswap /overlay/swap.page;
swapon /overlay/swap.page;
mount -o remount,size=256M /tmp;

echo "Updating rc.local for swap"
rm /etc/rc.local;
cat << "EOF" > /etc/rc.local
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.
###activate the swap file on the SD card  
swapon /overlay/swap.page  
###expand /tmp space  
mount -o remount,size=256M /tmp
exit 0
EOF

echo " "
echo "###############################"
echo "### Installing dependencies ###"
echo "###############################"
echo " "
opkg update
opkg install gcc make unzip htop wget-ssl git-http v4l-utils mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www
uci delete mjpg-streamer.core.username
uci delete mjpg-streamer.core.password

opkg install python3 python3-pip python3-dev python3-psutil python3-pillow
pip install --upgrade setuptools
pip install --upgrade pip

cd /


echo " "
echo "############################"
echo "### Installing Octoprint ###"
echo "############################"
echo " "
echo " Sit tight... "
echo " "

pip install Octoprint==1.8.1

echo " "
echo "##################################"
echo "### Creating Octoprint service ###"
echo "##################################"
echo " "

cat << "EOF" > /etc/init.d/octoprint
#!/bin/sh /etc/rc.common
# Copyright (C) 2009-2014 OpenWrt.org
# Put this inside /etc/init.d/

START=91
STOP=10
USE_PROCD=1


start_service() {
    procd_open_instance
    procd_set_param command octoprint serve --iknowwhatimdoing
    procd_set_param respawn
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
EOF

chmod +x /etc/init.d/octoprint
/etc/init.d/octoprint enable

echo " "
echo "########################################"
echo "### Installing timelapse packages... ###"
echo "########################################"
echo " "

rm -rf /tmp/opkg-lists
mkdir /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages.gz -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages.manifest -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages.sig -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/alsa-lib_1.2.4-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/fdk-aac_2.0.1-4_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/ffmpeg_4.3.2-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/ffprobe_4.3.2-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libatomic1_8.4.0-3_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libbz21.0_1.0.8-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libffmpeg-full_4.3.2-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libgmp10_6.2.1-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libgnutls_3.7.2-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libnettle8_3.6-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libx264_2020-10-26-1_mipsel_24kc.ipk -P /tmp/ffmpeg;
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/shine_3.1.1-1_mipsel_24kc.ipk -P /tmp/ffmpeg;

cd /tmp/ffmpeg
opkg install *.ipk --force-overwrite

echo " "
echo "##################################"
echo "### Reboot and wait a while... ###"
echo "##################################"
echo " "
read -p "Press [ENTER] to reboot...or [ctrl+c] to exit"

reboot
