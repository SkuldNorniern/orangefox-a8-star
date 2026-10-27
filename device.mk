LOCAL_PATH := device/samsung/astarqlte

# Stock launched on Oreo (API 26)
PRODUCT_SHIPPING_API_LEVEL := 26

# fastbootd is useless on Samsung (no fastboot in LK)
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl.recovery

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.board=sdm660 \
    ro.chipname=SDM660
