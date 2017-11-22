# Provides overrides to configure the Dalvik heap for a standard medium density
# wearable with around 128MB total RAM.

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=5m \
    dalvik.vm.heapgrowthlimit=32m \
    dalvik.vm.heapsize=64m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=2m
