#!/bin/bash
read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo '3.4 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo '3.5 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -Syy
pacman -S dialog dhcpcd wpa_supplicant broadcom-wl iproute2 iw --noconfirm 

echo 'Добавляем пользователя'
useradd -m -g users -G audio,games,lp,optical,power,scanner,storage,video,wheel -s /bin/bash $username

echo 'Создаем root пароль'
passwd

echo 'Устанавливаем пароль пользователя'
passwd $username

echo 'Устанавливаем SUDO'
echo 'lljk ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "Куда устанавливем Arch Linux на виртуальную машину?"
read -p "1 - Да, 0 - Нет: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit xorg-apps mesa-libgl xterm"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi

echo 'Ставим иксы и драйвера'
pacman -S $gui_install
pacman -S xfce4 xfce4-goodies git --noconfirm
#echo "Какое DE ставим?"
#read -p "1 - XFCE, 2 - KDE, 3 - Openbox: " vm_setting
#if [[ $vm_setting == 1 ]]; then
 # pacman -S xfce4 xfce4-goodies --noconfirm
#elif [[ $vm_setting == 2 ]]; then
 # pacman -Sy plasma-meta kdebase --noconfirm
#elif [[ $vm_setting == 3 ]]; then  
#  pacman -S  openbox xfce4-terminal
#fi

#echo 'Cтавим Slim'
#pacman -S slim --noconfirm
#systemctl enable slim

#echo 'Cтавим lxdm'
#pacman -S lxdm --noconfirm
#systemctl enable lxdm

echo 'Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu opendesktop-fonts ttf-bitstream-vera ttf-arphic-ukai ttf-arphic-uming ttf-hanazono --noconfirm 

echo 'Ставим сеть'
pacman -S networkmanager network-manager-applet modemmanager ppp --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo 'Установить звук?'
read -p "1 - Да, 0 - Нет: " soundprog_set
if [[ $soundprog_set == 1 ]]; then
  sudo pacman -S alsa-utils pulseaudio pulseaudio-alsa pavucontrol --noconfirm
elif [[ $soundprog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi

echo 'Установка программ'
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
 sudo pacman -S chromium vlc screenfetch usbutils bash-completion qbittorrent ntfs-3g p7zip unrar gvfs --noconfirm
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi

echo 'Установка доп программ'
read -p "1 - Да, 0 - Нет: " dopprog_set
if [[ $dopprog_set == 1 ]]; then
 sudo pacman -S f2fs-tools conky htop modemmanager ppp hddtemp net-tools simplescreenrecorder guvcview tox galculator --noconfirm
elif [[ $dopprog_set == 0 ]]; then
  echo 'Установка доп программ пропущена.'
fi

echo 'Создаем папку downloads'
  mkdir /home/Alex/downloads
  chmod 777 /home/Alex/downloads
  cd /home/Alex/downloads

echo 'Создаем нужные директории'
  sudo pacman -S xdg-user-dirs --noconfirm
  xdg-user-dirs-update

echo 'Ставим обои темы и иконки'
  echo 'Ставим обои'
  wget -P /home/Alex/downloads/ https://git.io/dimwalp.jpg
  wget -P /home/Alex/downloads/ https://git.io/dimwalp1.jpg
  sudo rm -rf /usr/share/backgrounds/xfce/* #Удаляем стандартрые обои
  sudo mv -f /home/Alex/downloads/dimwalp.jpg /usr/share/backgrounds/xfce/dimwalp.jpg
  sudo mv -f /home/Alex/downloads/dimwalp1.jpg /usr/share/backgrounds/xfce/dimwalp1.jpg
  
  echo 'Ставим лого ArchLinux в меню'
  wget -P /home/Alex/ git.io/arch_logo.png
  sudo mv -f /home/Alex/arch_logo.png /usr/share/pixmaps/arch_logo.png
  
  echo 'Ставим настройки'
  wget -P /home/Alex/downloads/ https://github.com/lljkee/arch/raw/master/attach/dimxfce4.tar.gz
  rm -rf /home/Alex/.config/xfce4/panel/
  rm -rf /home/Alex/.config/xfce4/*
  tar -xzf /home/Alex/downloads/dimxfce4.tar.gz -C /home/Alex/.config/  
  
  echo 'Ставим иконки'
  wget -P /home/Alex/downloads/ https://github.com/lljkee/arch/raw/master/attach/iconsxfce4.tar.gz
  tar -xzf /home/Alex/downloads/iconsxfce4.tar.gz -C /home/Alex/
  
  echo 'Ставим темы'
  wget -P /home/Alex/downloads/ https://github.com/lljkee/arch/raw/master/attach/themesxfce4.tar.gz
  tar -xzf /home/Alex/downloads/themesxfce4.tar.gz -C /home/Alex/
  
  #echo 'Ставим conky'
  #wget -P /home/lljk/downloads/ https://github.com/lljkee/arch/raw/master/attach/conky.tar.gz
  #tar -xzf /home/lljk/downloads/conky.tar.gz -C /home/lljk/.config/
  
  echo 'Добавляем иконки'
  gtk-update-icon-cache /home/Alex/.icons/nouveGnomeGray/
  gtk-update-icon-cache /home/Alex/.icons/vamox-argentum/
  
  echo 'Настраиваем вид bash'
  rm /home/Alex/.bashrc
  wget -P /home/Alex/ https://raw.githubusercontent.com/lljkee/arch/master/attach/.bashrc
  
  echo 'Установить Bluetooth?'#read -p "1 - Да, 0 - Нет: " btprog_set
if [[ $btprog_set == 1 ]]; then
  sudo pacman -S bluez blueman bluez-utils bluez-hid2hci pulseaudio-bluetooth --noconfirm
  sudo systemctl enable bluetooth.service --noconfirm
  wget -P /home/Alex/downloads/ https://git.io/brcm.tar.gz
  tar -xzf /home/Alex/downloads/brcm.tar.gz
  sudo mv /home/Alex/downloads/brcm/* /lib/firmware/brcm/
elif [[ $btprog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi

echo 'Установка автозапуска'
rm /home/Alex/.xinitrc
wget -P /home/Alex/ https://git.io/.xinitrc

rm /home/Alex/.bash_profile
wget -P /home/Alex/ https://git.io/.bash_profile

sudo mkdir /etc/systemd/system/getty@tty1.service.d
sudo wget -P /etc/systemd/system/getty@tty1.service.d/ https://git.io/override.conf

echo 'Установка завершена! Перезагрузите систему.'

#wget git.io/aurdim.sh && sh aurdim.sh

exit
