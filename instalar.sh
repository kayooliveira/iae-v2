#!/bin/bash
loadkeys br-abnt2

lsblk
read "Entre com o disco que será particionado: " disco
cfdisk $disco

read "Entre com a partição que será /boot: " bt
read "Entre com a partição que será a /" rt
read "Entre com a partição que será a swap" sp
read "Entre com a partição que será a /home" hm

# Formatação das partições
mkfs.vfat -F32 /dev/$bt
mkfs.ext4 /dev/$rt
mkfs.ext4 /dev/$hm
mkswap /dev/$sp

# Montagem das partições
mount /dev/$rt /mnt
mkdir -p /mnt/boot/efi
mount /dev/$bt /mnt/boot/efi
swapon /dev/$sp
mkdir /mnt/home
mount /dev/$hm /mnt/home

pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

arch-chroot "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot "hwclock --systohc"

# nano /etc/locale.gen
locale-gen

echo LANG=pt_BR.UTF-8 > /etc/locale.conf
localectl set-x11-keymap br abnt2

read "Entre com o nome do computador:" ht
echo $ht > /etc/hostname
passwd

read "Entre com o nome do usuário:" usr
useradd -m -G wheel -s /bin/bash $usr
passwd $usr

# EDITOR=nano visudo

pacman -S grub efibootmgr
grub-install /dev/$disco
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S $(< pacotes-base)
systemctl enable NetworkManager
systemctl enable lightdm
systemctl enable tlp

cat 20-intel.conf > /etc/X11/xorg.conf.d/20-intel.conf

exit
umount -a
reboot
