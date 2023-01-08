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

**Use whatever tool you want, but I'm only officially supporting Etcher.**

1. Download [Etcher](https://etcher.io) and the ISO from releases.
2. Open the ``.iso`` you downloaded in Etcher.
3. Write it to your USB drive.
4. Reboot and enter your BIOS's boot menu.
5. Select the USB drive.

## Building

* The ``CRSOURCE`` variable is the direct link to the build of checkra1n that will be used.
* Add something to the ``VERSION`` variable if you want to redistribute your image, i.e., ``1.0.6-foo``.

```sh
sudo apt install -y curl ca-certificates tar gzip grub2-common grub-pc-bin grub-efi-amd64-bin xorriso mtools
sudo ./build.sh
```
