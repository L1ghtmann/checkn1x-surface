<div align="center">
<picture>
<source media="(prefers-color-scheme: dark)" srcset="icon_light.png">
<img src="icon_dark.png" alt="icon">
</picture>

# checkn1x-surface

Linux-based distribution (with Surface support) for jailbreaking iOS devices w/ checkra1n.
</div>

## Downloads

Downloads are available under [releases](https://github.com/l1ghtmann/checkn1x-surface/releases).

## Usage
### Etcher
1. Download [Etcher](https://etcher.io) and the ISO from releases.
2. Open the ``.iso`` you downloaded in Etcher.
3. Write it to your USB drive.
4. Reboot and enter your BIOS's boot menu.
5. Select the USB drive.

### Rufus
1. Download [Rufus](https://rufus.ie/en/) and the ISO from releases.
2. Select the ``.iso`` you downloaded in Rufus.
3. Start the iso flash and select 'Write in DD Image Mode' when prompted.
4. Reboot and enter your BIOS's boot menu.
5. Select the USB drive.

## Building

* The ``CRBINARY`` variable is the direct link to the build of checkra1n that will be used.
* Add something to the ``VERSION`` variable if you want to redistribute your image, i.e., ``1.0.6-foo``.

```sh
sudo apt install -y ca-certificates cpio curl debootstrap grub2-common grub-efi-amd64-bin grub-pc-bin gzip mtools tar xorriso xz-utils
sudo ./build.sh
```

## References
- https://unix.stackexchange.com/questions/91620/efi-variables-are-not-supported-on-this-system
- https://unix.stackexchange.com/questions/693101/reinstall-grub-grub-install-warning-efi-variables-are-not-supported-on-this-s
- https://askubuntu.com/questions/86483/how-can-i-see-or-change-default-run-level
- https://docs.oracle.com/cd/E19683-01/817-3814/6mjcp0qgg/index.html
- https://docs.oracle.com/cd/E19683-01/817-3814/6mjcp0qgh/index.html
- https://unix.stackexchange.com/questions/115231/how-to-replace-sysvinit-with-systemd-in-a-debian-based-distribution
- https://superuser.com/questions/969923/automatic-root-login-in-debian-8-0-console-only
- https://www.willhaley.com/blog/custom-debian-live-environment/
- https://www.ibm.com/docs/en/aix/7.2?topic=files-inittab-file
