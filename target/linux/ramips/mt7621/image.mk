define Device/xiaomi_mi-router-4
  $(Device/dsa-switch)
  DEVICE_VENDOR := Xiaomi
  DEVICE_MODEL := Mi Router 4
  SOC := mt7621
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_SIZE := 4194304
  IMAGE_SIZE := 88064k
  DEVICE_DTS := mt7621_xiaomi_mi-router-4
  DEVICE_PACKAGES := kmod-mt76x2
  IMAGES += factory.bin
  IMAGE/factory.bin := append-kernel | check-size $$$$(KERNEL_SIZE)
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += xiaomi_mi-router-4
