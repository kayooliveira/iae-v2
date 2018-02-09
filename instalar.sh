#!/bin/bash
loadkeys br-abnt2

lsblk
read "Entre com a partição que será /boot: " bt
read "Entre com a partição que será a /" rt
read "Entre com a partição que será a swap" sp
read "Entre com a partição que será a /home" hm

# mkfs.vfat -F32 /dev/sda1
mkfs.vfat -F32 /dev/$bt
# mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/$rt
# mkswap /dev/sda3
mkswap /dev/$sp

mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
swapon /dev/sda3
mkdir /mnt/home
mount /dev/sda4 /mnt/home

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

arch-chroot "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
arch-chroot "hwclock --systohc"
