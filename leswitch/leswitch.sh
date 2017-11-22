#!/system/bin/sh
set -e
mkdir -p /data/oem/etc
chmod 0751 /data/oem/etc
mkdir -p /data/oem/etc/sysconfig
chmod 0751 /data/oem/etc/sysconfig
cp /system/leswitch/cn_google_features.xml /data/oem/etc/sysconfig/
chmod 0644 /data/oem/etc/sysconfig/cn_google_features.xml
PRODUCT=`getprop ro.build.product`
{
    echo "ro.product.name=${PRODUCT}_sw";
    cat /system/leswitch/oem.prop;
    cat /data/oem/oem.prop;
} > /data/oem/oem_override.prop
chmod 0644 /data/oem/oem_override.prop
