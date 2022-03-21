## Flashing OpenWrt:  

### If you're box is currently on stock firmware:

Alternative Options:  
**A. Standard option**

1. Rename `*factory.bin` to `cxsw_update.tar.bz2`  
2. Copy it to the root of a FAT32 formatted microSD card.  
3. Turn on the device, wait for it to start, then insert the card. The stock firmware reads the `install.sh` script from this archive and flashes the new OpenWrt image.  
4. `ssh` into it with ethernet `ssh root@192.168.1.1` or get into serial baud: `57600`, enable radio in `/etc/config/wireless`, reboot, the box will create an AP `OpenWrt`- connect to it -> `ssh` and continue Wi-fi internet setup.

**B. Through the Stock firmware UI interface (link)**

**C. Using the `Recovery process`** see below  

### If your box is already on OpenWrt and has the luci web UI reachable:

Alternative Options:  
**A. Flashing another Openwrt binary:** Access the luci web UI -> Go to System -> Upgrade -> Uncheck the box that sais `Save configs` -> Upload the SYSUPGRADE bin -> Flash  
**B. Resetting the box** By holding the reset button for about 6 seconds the box will freshly reset the current OpenWrt firmware.  
**C. Using the `Recovery process`** see below  


## Recovery process  
If the box is either on stock or Openwrt but unreachable (semi bricked) 
:exclamation: With the recovery process you can restore stock firmware or install/recover Openwrt firmware regardless of what's already on the box.

**Recovering to Openwrt**  
1. Rename the SYSUPGRADE bin to `root_uImage`  
2. Put it on a fat32 formatted USB stick (not uSD card)  
3. With the box powerd off, plug the USB stick in the box  
4. Press and hold the reset button.  
5. While holding the reset button power on the box and keep it pressed for about 6-10sec  
6. Leds should start flashing while the box installs the firmware  
7. Let it be for a couple of minutes until you see it on the network (`OctoWrt` WiFi AP )  

**Restoring to Stock**  
1. Extract the `root_uImage` file from the `cxsw_update.tar.bz2`   
2 - 6. Same steps as above  
7. You should see the creality AP
