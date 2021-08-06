# OctoWrt
A guide to install Octoprint on the Creality WiFi Box or similar OpenWrt devices

<details>
  <summary>Click to expand demo video!</summary>

https://user-images.githubusercontent.com/40600040/128418449-79f69b98-8f81-4315-b18a-8869d186eed6.mp4


 
</details>

-----------

## ⚠️ Work in Progress ⚠️

It is recommended to use the python 3 approach since python 2 got deprecated since January 1st, 2020. However, if you want older versions of Octoprint, python 2 approach might be the only way.

----------

#### 1. Install OpenWrt dependencies:

```
opkg update
opkg install gcc make unzip htop wget-ssl git-http
opkg install v4l-utils mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www
```

------------------------------

* #### Python 3:

<details>
  <summary>Expand steps!</summary>

```
opkg install python3 python3-pip python3-dev 
pip install --upgrade setuptools
```

 </details>
 
#### OR
  
* #### Python 2:

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

`pip install Octprint==1.6.1`

#### 3. Create octoprint service:
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
▶️ _Note!_  
Booting on the last versions takes a while (~5 minutes). Once booted however, everything works as expected. If you care that much about this you can install older versions (v1.0.0 for example) hat are much lighter but are not plugin enabled. Only Temps, Control, Webcam and Gcode preview. 
