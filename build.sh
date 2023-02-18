#!/usr/bin/env bash
#
# checkn1x-surface build script
# OG script by https://asineth.me/
#
VERSION="1.0.0"
CRBINARY="https://assets.checkra.in/downloads/linux/cli/x86_64/dac9968939ea6e6bfbdedeb41d7e2579c4711dc2c5083f91dced66ca397dc51d/checkra1n"

if [[ $EUID -ne 0 ]]; then
	echo "$0: This script must be run with sudo or as su. Exiting."
	exit 1
elif ! [[ -x $(command -v debootstrap) ]]; then
	echo "$0: debootstrap not installed. Exiting."
	exit 2
fi

# clean up previous attempt
umount -v work/rootfs/{dev,sys,proc} >/dev/null 2>&1
rm -rf work
mkdir -pv work/{rootfs,iso/boot/}
cd work

# build rootfs
# TODO
#	 https://github.com/linux-surface/surface-aggregator-module/wiki/Testing-and-Installing
#	 apt install -y --no-install-recommends linux-surface-secureboot-mok
debootstrap --arch=amd64 --variant=minbase bullseye rootfs http://ftp.us.debian.org/debian/
mount -vo bind /dev rootfs/dev
mount -vt sysfs sysfs rootfs/sys
mount -vt proc proc rootfs/proc
cat << ! | chroot rootfs
echo "mindebian" > /etc/hostname
apt update && apt upgrade -y
apt install -y --no-install-recommends linux-image-amd64 systemd grub2-common
apt install -y --no-install-recommends libusbmuxd-tools ncurses-base openssh-client sshpass usbutils usbmuxd
apt clean
!

# fetch resources
curl -Lo rootfs/usr/local/bin/checkra1n "$CRBINARY"

# copy files
cp -av ../checkn1x.service rootfs/etc/systemd/system/
cp -av ../checkn1x_welcome rootfs/usr/local/bin/
chmod -v 755 rootfs/usr/local/bin/*

# systemd config
cat << ! | chroot rootfs
systemctl enable checkn1x.service
sed -i 's/--noclear/--noclear -a root/g' /lib/systemd/system/getty@.service
mkdir -p /boot/grub/
grub-mkconfig > /boot/grub/grub.cfg
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /usr/share/grub/default/grub
!

# unmount fs
umount -v rootfs/{dev,sys,proc}

# boot config
FILE="$(ls rootfs/boot/vmlinuz-*)"
RAWREF="$(basename $FILE)"
VER=${RAWREF##*vmlinuz-}
mv -v rootfs/boot/grub/ iso/boot/
cp -av rootfs/boot/vmlinuz* rootfs/boot/config* rootfs/boot/System* iso/boot/
sed -i '$i checkn1x-surface $VERSION by Lightmann\nOG script by https://asineth.me\nOne moment please ....' iso/boot/grub/grub.cfg
# cat << ! > iso/boot/grub/grub.cfg
# insmod all_video
# echo 'checkn1x-surface $VERSION by Lightmann'
# echo 'OG script by https://asineth.me'
# echo 'One moment please ....'
# set root=(hd0,3)
# # set prefix=(hd0,3)/boot/grub
# linux /boot/vmlinuz initrd=initramfs.xz quiet loglevel=3 3
# initrd /boot/initramfs.xz
# boot
# !

# build custom initramfs
pushd rootfs/
rm -rfv tmp/* boot/* var/cache/* var/lib/apt/lists/* etc/resolv.conf
# find . -xtype l -delete -print
find . | cpio -oH newc | xz -C crc32 --x86 -vz9eT$(nproc --all) > ../iso/boot/initrd.img-$VER
popd

# iso creation
grub-mkrescue -o "checkn1x-surface-$VERSION.iso" iso --compress=xz
