# Create arch bootable usb 
Download arch iso from https://archlinux.org/download/ and put on a USB drive with Etcher or Rufus

# Important Note: 
This script will format your drive. 
Please make sure you don't have any important data on your drive or just backup your data first.

# INSTALLATION
Boot with live iso 
Connect to wifi:
0: Run `rfkill unblock wifi`
1: Run `iwctl`
2: Run `device list`, and find your device name
3: Run `station [DEVICE NAME] scan`
4: Run `station [DEVICE NAME] get-networks`, and find your network name
5: Run `station [DEVICE NAME] connect [NETWORK NAME]`, enter wifi password and run `exit`
You can test if you have internet connection by running `ping google.com`, and then Press Ctrl and C to stop the ping test.

Run following commands:
```
pacman -Sy git --noconfirm
git clone https:github.com/samay15jan/arch-install
cd arch-install
chmod u+x arch-install.sh
./arch-install.sh
```

Then enter hostname, username, user password and root password 

After installation finishes, reboot the system, login with your credentials and you are done with a clean arch install 

If you wanna install my configuration of i3wm then run arch-install3.sh 

# System Configuration 
This is a simple automated arch install script and by default will format your drive and make 3 partitions, 500mb efi, 2gb swap and leftover as root partition. 
You can have clean install after you reboot but if you wanna have my i3WM configuration you can run arch-install3.sh and it will automatically install all the necessary packages with my customized theme. Enjoy :)
