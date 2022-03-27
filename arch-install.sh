#!/bin/bash
clear
echo "
_ _ _ ____ _    ____ ____ _  _ ____    ___ ____    ____ ____ ____ _  _    _ _  _ ____ ___ ____ _    _    
| | | |___ |    |    |  | |\/| |___     |  |  |    |__| |__/ |    |__|    | |\ | [__   |  |__| |    |    
|_|_| |___ |___ |___ |__| |  | |___     |  |__|    |  | |  \ |___ |  |    | | \| ___]  |  |  | |___ |___ 

"

read -p "Please enter hostname: " hostname
read -p "Please enter username: " username
read -p "Please enter user password: " user_password
read -p "Please enter root password: " root_password
clear

# Step 1
loadkeys us
pacman --noconfirm -Sy archlinux-keyring
timedatectl set-ntp true
wipefs -a /dev/sda1
wipefs -a /dev/sda2
wipefs -a /dev/sda
sfdisk /dev/sda << EOF
,500m
;
EOF
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
clear
pacstrap /mnt base linux linux-firmware efibootmgr grub networkmanager sed nano sudo
genfstab -U /mnt >> /mnt/etc/fstab
echo "echo $hostname > /etc/hostname" >> /mnt/temp.sh
echo "useradd -m -G wheel -s /bin/bash $username" >> /mnt/temp.sh
echo "echo \"$username ALL=(ALL:ALL) ALL\" >> /etc/sudoers" >> /mnt/temp.sh
echo "echo $username:$user_password | chpasswd" >> /mnt/temp.sh
echo "echo root:$root_password | chpasswd" >> /mnt/temp.sh
chmod u+x /mnt/temp.sh 
sed '1,/^# Step 2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit

# Step 2
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
sed -i "/en_IN.UTF-8/s/^#//g" /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" > /etc/locale.conf
./temp.sh
rm -r /temp.sh
grub-install /dev/sda
sed -i 's/quiet/pci=noaer/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager.service
location= /home/arch_install3.sh
sed '1,/^# Step 3$/d' arch_install2.sh > /home/arch_install3.sh
chmod +x /home/arch_install3.sh
exit
clear
echo "INSTALLATION COMPLETED PLEASE RESTART"
sleep 10

# Step 3
sudo sed -i '38d' /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo echo "[Service]" >> /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo echo "ExecStart=" >> /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo echo "ExecStart=-/sbin/agetty -a $username %I" '$TERM' >> /etc/systemd/system/getty.target.wants/getty@tty1.service
pacman -Ss --noconfirm fonts ttf
pacman -S --noconfirm ttf-dejavu pango i3 dmenu ffmpeg jq curl \
        dmenu xorg-server xorg-xinit alacritty pavucontrol \
        light picom rofi git nautilus firefox gparted base-devel\
        gnome-boxes arandr feh bluez bluez-utils libreoffice \
        mpv neofetch qbittorrent code xorg-xprop sxiv nano \
        pulseaudio sysstat openssh xorg
clear     
rfkill unblock all
echo "exec i3 " >> ~/.xinitrc
systemctl start bluetooth.service
systemctl enable bluetooth.service
echo "Enter Username "
read username
sudo pacman -Sy git
cd /home/$username
git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $username:$username ./yay-git
cd yay-git
makepkg -si
yay -S --noconfirm pfetch 
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
sudo chmod u+x cpu_usage shutdown_menu
cd ~/.config/i3/rofi/bin
sudo chmod u+x network_menu launcher
cd ~/.config/i3/rofi/themes
sudo chmod u+x colors.rasi launcher.rasi network.rasi networkmenu.rasi networkmenu_config.rasi
sudo chown -R $username:$username .config/
sudo chown -R $username:username /usr/local/bin

### Manual processes

## Auto start i3wm on boot 
#          sudo nano /etc/profile  
#          if [["$(tty)"=='/dev/tty1']]; then
#          exec startx
#          fi

## To connect bluetooth manually
#          bluetoothctl
#          scan on 
#          connect [mac address] #mac address of device

