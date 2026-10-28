# OrangeFox for Galaxy A8 Star (astarqlte)

OrangeFox R12 (fox_12.1) device tree for the Galaxy A8 Star.
Tested on SM-G885S (SKT). Should work on SM-G885F/Y too, not tested.

- SoC: Snapdragon 660 (sdm660), eMMC
- Kernel: prebuilt 4.4.78 `Image.gz-dtb` from sabpprook's TWRP 3.2.3
- Maintainer: Eira

## Working

- boots, touch, brightness
- adb and MTP over USB
- /data, system/vendor image flashing
- Odin flashable tar

## Not working / not tested

- flashlight (wired to the Samsung `rear_flash` node, needs a test)
- reboot from recovery (fixed with a v2 `recovery.fstab`, needs a test)
- stock 4.4.205 kernel: root gets EACCES everywhere, adbd aborts. use 4.4.78

## Build

```bash
git clone https://gitlab.com/OrangeFox/sync.git && cd sync
./orangefox_sync.sh --branch 12.1 --path ~/fox_12.1

git clone https://github.com/SkuldNorniern/orangefox-a8-star ~/fox_12.1/device/samsung/astarqlte
bash ~/fox_12.1/device/samsung/astarqlte/patches/apply.sh ~/fox_12.1

cd ~/fox_12.1
source build/envsetup.sh
source device/samsung/astarqlte/vendorsetup.sh
lunch twrp_astarqlte-eng
rm -rf out/target/product/astarqlte/recovery
mka adbd recoveryimage
```

`patches/apply.sh` applies `patches/*.patch` (pixelflinger code cache, MTP start EBUSY on the kernel `/dev/mtp_usb`) and adds the maintainer picture.
Clear `out/.../recovery` before each build, old libs stay there otherwise.

## Flash

Bootloader unlocked (wipes data, trips Knox).
Download mode, Odin, AP = the `.tar`, untick Auto Reboot.
After PASS hold Vol- + Power, then Vol+ + Power right away so stock doesn't put its recovery back.

## Credits

- [OrangeFox](https://gitlab.com/OrangeFox), [TWRP](https://github.com/TeamWin)
- [sabpprook](https://github.com/sabpprook/android_device_samsung_astarqlte) for the first TWRP tree and the kernel
- [Jacob5106](https://github.com/Jacob5106) for the astarqlte / astarqltechn tree updates
