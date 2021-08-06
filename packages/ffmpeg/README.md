Before installing these ffmpeg packages delete opkg list : `rm -rf /tmp/opkg-lists`  
To download the packages, either clone this repo or use the following commands:  

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