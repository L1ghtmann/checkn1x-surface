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
elif [[ -x $(command -v debootstrap) ]]; then
	echo "$0: debootstrap not installed. Exiting."
	exit 2
fi

# clean up previous attempt
umount -v work/rootfs/dev >/dev/null 2>&1
umount -v work/rootfs/sys >/dev/null 2>&1
umount -vl work/rootfs/proc >/dev/null 2>&1
rm -rf work
mkdir -pv work/{rootfs,iso/boot/grub}
cd work

# build rootfs
debootstrap --arch=amd64 --variant=minbase bullseye rootfs http://ftp.us.debian.org/debian/
mount -vo bind /dev rootfs/dev
mount -vt sysfs sysfs rootfs/sys
mount -vt proc proc rootfs/proc
cat << ! | chroot rootfs
echo "minidebian" > /etc/hostname
apt update && apt upgrade -y
apt install -y --no-install-recommends linux-image-amd64 sysvinit-core openrc
apt install -y --no-install-recommends usbutils usbmuxd libusbmuxd-tools openssh-client sshpass ncurses-base terminfo
apt clean
!

# linux surface surface-aggregator-module
# -----TODO-----
# cat << ! | chroot rootfs
# apt install -y build-essential linux-headers-$(uname -r)
# git clone --depth=1 https://github.com/linux-surface/surface-aggregator-module surfacemod
# cd surfacemod/module/
# sed -e s/sudo//g Makefile
# make -j
# make insmod
# cd ../../ && rm -rvf surfacemod
# apt remove -y build-essential linux-headers-$(uname -r)
# apt autoremove -y && apt autoclean
# !

# unmount fs
umount -v rootfs/dev
umount -v rootfs/sys
umount -v rootfs/proc

# fetch resources
curl -Lo rootfs/usr/local/bin/checkra1n "$CRBINARY"

# copy files
cp -av ../inittab rootfs/etc
cp -av ../scripts/* rootfs/usr/local/bin
chmod -v 755 rootfs/usr/local/bin/*
ln -sv sbin/init rootfs/init
ln -sv ../../etc/terminfo rootfs/usr/share/terminfo # fix ncurses

# boot config
cp -av rootfs/boot/vmlinuz-* iso/boot/vmlinuz
cat << ! > iso/boot/grub/grub.cfg
insmod all_video
echo 'checkn1x-surface $VERSION'
echo 'OG script by https://asineth.me'
echo 'One moment please ....'
linux /boot/vmlinuz quiet loglevel=3 1
initrd /boot/initramfs.xz
boot
!

# build custom initramfs
# ~550 MB -> ~120 MB
pushd rootfs/
rm -rfv tmp/* boot/* var/cache/* /var/lib/apt/lists/* etc/resolv.conf
find . | cpio -oH newc | xz -C crc32 --x86 -vz9eT$(nproc --all) > ../iso/boot/initramfs.xz
popd

# iso creation
grub-mkrescue -o "checkn1x-surface-$VERSION.iso" iso --compress=xz
