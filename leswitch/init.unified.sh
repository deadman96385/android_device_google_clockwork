#!/system/bin/sh
# Recursively copy all /oem contents
cp -r --preserve=m /oem/. /data/oem/
# Create an empty oem.prop file if it doesn't exist
[ -f /data/oem/oem.prop ] || touch /data/oem/oem.prop
