⁷#!/bin/bash
printf= "
-------------------------------------------------------------------------------------------------------------------
| __        __   _                            _____          _             _          ___           _        _ _  |
| \ \      / /__| | ___ ___  _ __ ___   ___  |_   _|__      / \   _ __ ___| |__      |_ _|_ __  ___| |_ __ _| | | |
|  \ \ /\ / / _ \ |/ __/ _ \|  _   _ \ / _ \   | |/ _ \    / _ \ |  __/ __|  _ \      | ||  _ \/ __| __/ _  | | | |
|   \ V  V /  __/ | (_| (_) | | | | | |  __/   | | (_) |  / ___ \| | | (__| | | |     | || | | \__ \ || (_| | | | |
|    \_/\_/ \___|_|\___\___/|_| |_| |_|\___|   |_|\___/  /_/   \_\_|  \___|_| |_|    |___|_| |_|___/\__\__ _|_|_| |
|                                                                                                                 |
-------------------------------------------------------------------------------------------------------------------
"    
# Step 1
loadkeys us
pacman --noconfirm -Sy archlinux-keyring
timedatectl set-ntp true
sfdisk /dev/sda << EOF
,500m
,2g
;
EOF
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
swapon /dev/sda2
pacstrap /mnt base linux linux-firmware efibootmgr grub networkmanager base-devel
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^# Step 2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt
exit

# Step 2
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
pacman -S --noconfirm sed
sed -i "/en_IN.UTF-8/s/^#//g" /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" > /etc/locale.conf
echo "Enter hostname: "
read hostname
echo $hostname > /etc/hostname
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/bash $username
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "$username ALL=(ALL) ALL" >> /etc/sudoers
echo "User password:"
passwd $username
echo "root password:"
passwd 
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
pacman -Ss --noconfirm fonts ttf
pacman -S --noconfirm ttf-dejavu pango i3 dmenu ffmpeg jq curl dmenu xorg-server xorg-xinit alacritty pavucontrol light picom rofi git nautilus firefox gparted gnome-boxes arandr feh bluez bluez-utils libreoffice mpv neofetch qbittorrent code xorg-xprop sxiv nano pulseaudio sysstat 
rfkill unblock all
echo "exec i3 " >> ~/.xinitrc
systemctl enable NetworkManager.service
systemctl start bluetooth.service
systemctl enable bluetooth.service
echo "Please reboot"

location=/home/$username/arch_install3.sh
sed '1,/^# Step 3$/d' arch_install2.sh > $location
chown $username:$username $location
chmod +x $location
su -c $location -s /bin/sh $username
exit 
sudo reboot now

# Step 3
echo "Enter Username "
read username
sudo pacman -Sy git
cd /home/$username
git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $username:$username ./yay-git
cd yay-git
makepkg -si
yay -S --noconfirm pfetch 
cd /home/$username
git clone https://aur.archlinux.org/zoom.git
cd zoom
makepkg -si
sudo chmod +s /usr/bin/light
sudo curl -sL "https://raw.githubusercontent.com/Edesem/bluetooth-connect-script/main/bcn" -o /usr/local/bin/bluez
sudo chmod +x /usr/local/bin/bluez
cd /home/$username
git clone https://github.com/samay15jan/arch-install
sudo cp -r ~/arch-install/i3 ~/.config/
sudo cp -r ~/arch-install/bin /usr/local/
sudo cp -r ~/arch-install/Wallpaper /home/$username
cd /usr/local/bin
sudo chmod u+x bluez wald
cd ~/.config/i3/scripts 
sudo chmod u+x bandwidth battery cpu_usage shutdown_menu
cd ~/.config/i3/rofi/bin
sudo chmod u+x network_menu launcher
cd

### Manual processes

## auto login
#          sudo nano /etc/systemd/system/getty.target.wants/getty@tty1.service
#          ExecStart=
#          ExecStart=-/sbin/agetty -a $username %I $TERM 

## Auto start i3 on boot 
#          sudo nano /etc/profile 
#          if [["$(tty)"=='/dev/tty1']]; then
#          exec startx
#          fi

## To connect bluetooth manually
#          bluetoothctl
#          scan on 
#          connect [mac address] #mac address of device

