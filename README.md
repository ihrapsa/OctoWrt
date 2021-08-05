# OctoWrt
A guide to install Octoprint on the Creality WiFi Box or similar OpenWrt devices

#### 1. Install OpenWrt dependencies:
**original `distfeeds.conf`**:

```
opkg update
opkg install gcc make unzip htop wget-ssl
opkg install v4l-utils mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www
```

**v19.07.7 `distfeeds.conf`**

```
opkg update
opkg install python python-pip python-dev 
pip install --upgrade setuptools
```

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
