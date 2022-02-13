# OctoWrt

<p align="left">
<img height=100 src="img/OctoPrint+OpenWrt.png">
</p>

A guide to install OctoPrint on the Creality WiFi Box or similar OpenWrt devices.

------------------

#### What is the Creality [Wi-Fi Box](https://www.creality.com/goods-detail/creality-box-3d-printer)?

<details>
  <summary>Click to expand info!</summary>

[<img align=center src="https://user-images.githubusercontent.com/40600040/128502047-f25d9156-31a8-4bc9-b0ed-45200cdfe411.png">](https://www.creality.com/goods-detail/creality-box-3d-printer)  
  = A router box device released by Creality meant to add cloud control to your printer. Comes with closed source and proprietary software. However, some people might not like that.

**Specifications:**

 (_taken form figgyc's commit_)

- **SoC**: MediaTek MT7688AN @ 580 MHz  
- **Flash**: BoyaMicro BY25Q128AS (16 MiB, SPI NOR)  
- **RAM**: 128 MiB DDR2 (Winbond W971GG6SB-25)  
- **Peripheral**: Genesys Logic GL850G 2 port USB 2.0 hub  
- **I/O**: 1x 10/100 Ethernet port, microSD SD-XC Class 10 slot, 4x LEDs, 2x USB 2.0 ports, micro USB input (for power only), reset button  
- **FCC ID**: 2AXH6CREALITY-BOX  
- **UART**: test pads: (square on silkscreen) 3V3, TX, RX, GND; default baudrate: 57600  
  
  </details>
  

#### Demo:
<details>
  <summary>Click to expand demo video!</summary>

https://user-images.githubusercontent.com/40600040/128418449-79f69b98-8f81-4315-b18a-8869d186eed6.mp4

</details>

------------------

## ⤵️ Preparing:

<details>
  <summary>Expand steps!</summary>
  
* **OpenWrt**: Make sure you've got OpenWrt flashed. Preferably one of [those](https://github.com/ihrapsa/KlipperWrt/tree/main/Firmware/OpenWrt_snapshot) images (since they come with preinstalled drivers for serial communications and webcam support) -> Once flashed setup Wi-Fi client or wired connection for internet access on the box
* **Distfeeds fix**

  >
      mv /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf_orig_old;
      mv /etc/opkg.conf /etc/opkg.conf_orig;

  _(copy/paste the entire block and execute it)_
  >
      cat << "EOF" > /etc/opkg/distfeeds.conf
      src/gz openwrt_core https://downloads.openwrt.org/releases/21.02.1/targets/ramips/mt76x8/packages
      src/gz openwrt_base https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/base
      src/gz openwrt_luci https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/luci
      src/gz openwrt_packages https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/packages
      src/gz openwrt_routing https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/routing
      src/gz openwrt_telephony https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/telephony
      EOF
  
    _(copy/paste the entire block and execute it)_
  >
      cat << "EOF" > /etc/opkg.conf
      dest root /
      dest ram /tmp
      lists_dir ext /var/opkg-lists
      option overlay_root /overlay
      #option check_signature
      EOF
  
* **Extroot**: execute [this](https://github.com/ihrapsa/KlipperWrt/blob/main/scripts/1_format_extroot.sh) script. Make sure to have a microsd plugged
  
  ```
  cd ~
  wget https://github.com/ihrapsa/KlipperWrt/raw/main/scripts/1_format_extroot.sh
  chmod +x 1_format_extroot.sh
  ./1_format_extroot.sh
  ```
  
* **Swap**: 

  ```
  opkg update && opkg install swap-utils zram-swap
  ```
  ```
  dd if=/dev/zero of=/overlay/swap.page bs=1M count=512;
  mkswap /overlay/swap.page;
  swapon /overlay/swap.page;
  mount -o remount,size=256M /tmp;
  ```
  ```
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
  ```
  
</details>

## ⤵️ Installing:

<details>
  <summary>Expand steps!</summary>

#### 1. Install OpenWrt dependencies:

```
opkg update
opkg install gcc make unzip htop wget-ssl git-http
opkg install v4l-utils mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www
```
By default mjpg-streamer comes with username=openwrt and password=openwrt. If you don't want them do:

```
uci delete mjpg-streamer.core.username
uci delete mjpg-streamer.core.password
```

------------------------------

* **Python 3**:

⚠️ _It is recommended to use the python 3 approach since python 2 got deprecated since January 1st, 2020. However, if you want older versions of Octoprint, python 2 approach might be the only way._
  
<details>
  <summary>Expand steps!</summary>

Install python 3 packages
```
opkg install python3 python3-pip python3-dev python3-psutil python3-netifaces python3-pillow
pip install --upgrade setuptools
```
  Install cross compiled python 3 packages:
```
cd /tmp
wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/python3.9-regex-2022.1.18+netifaces-0.11.0_mipsel_24kc.ipk
opkg install *.ipk --force-overwrite
```
 </details>
 
#### OR
  
* **Python 2**:

<details>
  <summary>Expand steps!</summary>
  
**v19.07.7 `distfeeds.conf`**
  * Backup original `distfeeds.conf`
```
mv /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf_orig
```

  * Create v19 `distfeeds.conf`
```
cat << "EOF" > /etc/opkg/distfeeds.conf
src/gz openwrt_core https://downloads.openwrt.org/releases/19.07.7/targets/ramips/mt76x8/packages
src/gz openwrt_base https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/base
src/gz openwrt_luci https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/luci
src/gz openwrt_packages https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/packages
src/gz openwrt_routing https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/routing
src/gz openwrt_telephony https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/telephony
EOF
```
  * Install python 2 packages
```
opkg update
opkg install python python-pip python-dev 
pip install --upgrade setuptools
```

  </details>

--------------------

#### 2. Install Octoprint:

`pip install Octoprint==1.7.3`

#### 3. Create octoprint service:
  
  <details>
    <summary> Expand </summary>
  
  ```
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
  ```
  </details>
  
#### 4. Make it executable:

```
chmod +x /etc/init.d/octoprint
```
#### 5. Enable the service:

```
service octoprint enable
``` 

#### 6. Reboot and wait a while

```
reboot
```

▶️ _**Note!**_  
_Booting on the last versions takes a while (~5 minutes). Once booted however, everything works as expected. If you care that much about this you can install older versions (v1.0.0 for example) that are much lighter but are not plugin enabled. Only Temps, Control, Webcam and Gcode preview._
  
#### 7. First setup
  
<details>
  <summary> Expand steps </summary>
  
Access Octoprint UI on port 5000
  
```
http://box-ip:5000
```
  
When prompted use thefollowing **server commands**:

  - Restart OctoPrint : `/etc/init.d/octoprint restart`  
  - Restart system : `reboot`  
  - Shutdown system : `poweroff`  

For **webcam** support:  
  
  `/etc/config/mjpg-streamer` is the configuration file. Modify that to change resolution, fps, user, pass etc.  
  Inside OctoPrint snapshot and stream fields add the following:
  - Stream URL: `http://your-box-ip:8080/?action=stream`  
  - Snapshot URL: `http://your-box-ip:8080/?action=snapshot` 
  
  If webcam not showing, unplug and replug it.  
  If you don't want webcam authentication you can comment or delete the user and password lines inside `mjpg-streamer` config file. Make sure to restart it after that:  `/etc/init.d/mjpg-streamer restart`
  
  </details>
  
  #### 8. Timelapse plugin setup
        
* _ffmpeg packages_
  
  <details> 
    <summary> Expand steps </summary>

    Before installing these ffmpeg packages delete opkg list :

    ```
    rm -rf /tmp/opkg-lists
    ```

    To download the packages use the following commands:  

    ```
    mkdir /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages.gz -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages.manifest -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/Packages.sig -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/alsa-lib_1.2.4-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/fdk-aac_2.0.1-4_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/ffmpeg_4.3.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/ffprobe_4.3.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libatomic1_8.4.0-3_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libbz21.0_1.0.8-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libffmpeg-full_4.3.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libgmp10_6.2.1-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libgnutls_3.7.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libnettle8_3.6-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/libx264_2020-10-26-1_mipsel_24kc.ipk -P /root/ffmpeg;
    wget https://github.com/ihrapsa/OctoWrt/raw/main/packages/ffmpeg/shine_3.1.1-1_mipsel_24kc.ipk -P /root/ffmpeg;
    ```

    Files will download to `/root/ffmpeg`  
    To install them:

    ```
    cd /root/ffmpeg
    opkg install *.ipk --force-overwrite
    ```
  </details>

* _ffmpeg bin path_
  
  <details>
    <summary> Expand steps </summary>
    
    In octoprint settings set the ffmpeg binary path as:
    
    ```
    /usr/bin/ffmpeg
    ```
    
   </details
  
</details>

-------------------------

## 🔝 Credits:

<img width=20 align=center src="https://user-images.githubusercontent.com/40600040/128488418-c703c383-1835-49a0-aa41-eadee0671ab7.png">  **Gina and co.** for creating and developping [OctoPrint](https://github.com/OctoPrint/OctoPrint)  
<img width=20 align=center src="https://user-images.githubusercontent.com/40600040/128488057-52b688f7-25d5-46e1-9ac8-bb5309384d98.png">  **George** a.k.a [figgyc](https://github.com/figgyc) for porting OpenWrt to this device  
