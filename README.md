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

## Notes
- You will need to disable SecureBoot if you have it enabled in order to boot from the USB.
  - See https://support.microsoft.com/en-us/surface/how-to-use-surface-uefi-df2c8942-dfa0-859d-4394-95f45eb1c3f9 for more info.
- You will need to have the function key (Fn) selected *before* you choose an option via the respective numbered function key (e.g., F1, F2, etc).

## Building
* The ``CRBINARY`` variable is the direct link to the build of checkra1n that will be used.
* Add something to the ``VERSION`` variable if you want to redistribute your image, i.e., ``1.0.6-foo``.

```sh
sudo apt install -y ca-certificates cpio curl debootstrap grub2-common grub-efi-amd64-bin grub-pc-bin gzip mtools tar xorriso xz-utils
sudo ./build.sh
```

## Credits
- [asineth](https://github.com/asineth0/checkn1x) for checkn1x
- [linux-surface](https://github.com/linux-surface/surface-aggregator-module) for the surface-aggregator-module
- [stackoverflow](https://stackoverflow.com/a/67920337)/[askubuntu](https://askubuntu.com/a/1126732)/[debian forums](https://forums.debian.net/viewtopic.php?t=127358) for misc. information

## TODO
- Port sysvinit to systemd (will auto-mount efivarfs needed for SecureBoot)
- Figure out configuration issue(s) with linux-surface kernel freezing on boot
