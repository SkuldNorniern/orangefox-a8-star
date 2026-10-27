#
# Galaxy A8 Star (astarqlte) - OrangeFox fox_12.1 / TWRP twrp-12.1
#

DEVICE_PATH := device/samsung/astarqlte

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo

TARGET_SUPPORTS_64_BIT_APPS := true

# Bootloader / platform
TARGET_BOOTLOADER_BOARD_NAME := sdm660
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := sdm660
TARGET_BOARD_PLATFORM_GPU := qcom-adreno512
QCOM_BOARD_PLATFORMS += sdm660
TARGET_USES_UEFI := false

# Kernel - prebuilt Linux 4.4.78 Image.gz-dtb from sabpprook TWRP 3.2.3
# (2018, board-id 0x8 0x7 DTB matches SM-G885S rev 7). No DEFEX/PROCA.
# The stock SM-G885S 4.4.205 kernel (G885SKSU4CVG1) doesn't work here: even
# with DEFEX hexpatched, root (init included) gets EACCES on exec/chmod/
# sysfs/configfs and adbd aborts, so there is no USB.
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x02000000
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_KERNEL_TAGS_OFFSET := 0x01e00000
BOARD_BOOT_HEADER_VERSION := 0
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
BOARD_KERNEL_CMDLINE := console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37
BOARD_KERNEL_CMDLINE += ehci-hcd.park=3 lpm_levels.sleep_disabled=1 sched_enable_hmp=1
BOARD_KERNEL_CMDLINE += sched_enable_power_aware=1 service_locator.enable=1 swiotlb=1
BOARD_KERNEL_CMDLINE += androidboot.configfs=true androidboot.usbcontroller=a800000.dwc3
BOARD_KERNEL_CMDLINE += loop.max_part=7 androidboot.selinux=permissive
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_SECOND_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)

# Ramdisk: kernel has CONFIG_RD_LZMA=y (no XZ/LZ4). LZMA keeps the image
# well under the 64 MiB recovery partition.
LZMA_RAMDISK_TARGETS := recovery
BOARD_RAMDISK_USE_LZMA := true

# Partitions
# boot and recovery are 64 MiB each (read on SM-G885S)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SUPPRESS_SECURE_ERASE := true

# Not A/B, no dynamic partitions, no AVB on this Oreo-launch Samsung
AB_OTA_UPDATER := false
BOARD_AVB_ENABLE := false
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
# fb0 on 4.4.78 shows correct colors with RGBX_8888. (On the stock 4.4.205
# kernel the default swapped red/blue and BGRA drew no images.)
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_QCOM_RTC_FIX := true
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_USES_RECOVERY_AS_BOOT := false

# Anti-rollback: recovery doesn't care, keymaster later might
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)

# TWRP
TW_THEME := portrait_hdpi
TW_FRAMERATE := 60
TW_Y_OFFSET := 0
TW_H_OFFSET := 0
# Brightness: on 4.4.78 backlight/panel is a dummy (max 0); the real control
# is leds/lcd-backlight, max 365 (read on device).
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 365
TW_DEFAULT_BRIGHTNESS := 200
# The S6E3FA7 cmd-mode panel only lights up after a blank/unblank cycle at
# GUI start; without it the screen stays off.
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_EXTRA_LANGUAGES := true
TW_USE_TOOLBOX := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_EXCLUDE_APEX := true
TW_HAS_DOWNLOAD_MODE := true
TW_NO_REBOOT_BOOTLOADER := true
TW_NO_FASTBOOT_BOOT := true
TW_EXCLUDE_TWRPAPP := true
TW_DEVICE_VERSION := HackOS-1

# Battery %: read sysfs, this recovery runs no health HAL.
TW_USE_LEGACY_BATTERY_SERVICES := true
TW_CUSTOM_BATTERY_PATH := "/sys/class/power_supply/battery"

# MTP: kernel has CONFIG_USB_CONFIGFS_F_MTP=y (mtp.gs0); the configfs
# mtp,adb rules are in init.recovery.qcom.rc.
TW_HAS_MTP := true

# Don't merge /vendor/etc/fstab.qcom: recovery.fstab already lists every
# partition, and a failed copy to /etc/additional.fstab makes TWRP 12.1
# fgets(NULL) -> SIGABRT -> crash loop (seen on device).
TW_SKIP_ADDITIONAL_FSTAB := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file

# Crypto (phase 2): needs keymaster 3.0 + qseecomd blobs from G885SKSU4CVG1 vendor.
# TW_INCLUDE_CRYPTO := true

# Logging (logcat in recovery)
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
