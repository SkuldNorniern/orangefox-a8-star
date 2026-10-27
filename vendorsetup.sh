# OrangeFox build vars for astarqlte. Sourced by build/envsetup.sh.
# Names checked against vendor/recovery/OrangeFox_vendor.sh (fox_12.1).

export FOX_MAINTAINER_PATCH_VERSION=1
export FOX_VARIANT=HackOS
export FOX_BUILD_TYPE=Unofficial
export OF_MAINTAINER=Eira
export FOX_TARGET_DEVICES=astarqlte
export TARGET_DEVICE_ALT=astarqlte,a8star,SM-G885S,SM-G885F,SM-G885Y

# Screen 1080x2220, no notch
export OF_SCREEN_H=2220
export OF_STATUS_H=80
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_ALLOW_DISABLE_NAVBAR=0

# Flashlight - Samsung camera flash node, wrapped in /tmp/flashlight by init
export OF_FLASHLIGHT_ENABLE=1
export OF_FL_PATH1=/tmp/flashlight

# Non-A/B, no AVB, no Treble checks
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_USE_MAGISKBOOT=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
export OF_KEEP_DM_VERITY_FORCED_ENCRYPTION=0

# Samsung: OrangeFox makes its own Odin tar (entry name recovery.img)
export FOX_SAMSUNG_DEVICE=1

# Keep the image small
export FOX_DELETE_AROMAFM=1
export FOX_REMOVE_AAPT=1
export OF_USE_LZMA_COMPRESSION=1

export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL=C
