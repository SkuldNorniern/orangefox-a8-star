#
# Galaxy A8 Star (SM-G885S / SM-G885F) - OrangeFox / TWRP 12.1
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/samsung/astarqlte/device.mk)

PRODUCT_DEVICE := astarqlte
PRODUCT_NAME := twrp_astarqlte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G885S
PRODUCT_MANUFACTURER := samsung
PRODUCT_RELEASE_NAME := Galaxy A8 Star
