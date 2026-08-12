define Device/bdy_g18-pro
  $(Device/u-boot-separate)
  $(Device/uefi-lp5)
  DEVICE_VENDOR := BDY
  DEVICE_MODEL := G18 Pro
  SOC := rk3568
  DEVICE_DTS := rockchip/rk3568-bdy-g18-pro
  UBOOT_DEVICE_NAME := bdy-g18-pro-rk3568
  IMAGE/sysupgrade.itb := kernel-bin | gzip | append-u-boot-rk3568-sd
  IMAGES += recovery.img
  IMAGE/recovery.img := partition Recovery | rkdevalrom
endef
TARGET_DEVICES += bdy_g18-pro
