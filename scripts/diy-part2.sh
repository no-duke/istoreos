#!/bin/bash
# ============================================================
# DIY Part 2 - Executed AFTER feeds install, BEFORE make
# Adds ZN-M2 device support to ImmortalWrt v25.12.1
# ============================================================

set -e

echo "============================================"
echo " DIY Part 2: Adding ZN-M2 device support"
echo "============================================"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Add ZN-M2 device definition to ipq60xx.mk
echo "[1/6] Adding ZN-M2 device definition to ipq60xx.mk..."
IPQ60XX_MK="target/linux/qualcommax/image/ipq60xx.mk"

if [ -f "$IPQ60XX_MK" ]; then
    # Check if zn_m2 already exists
    if grep -q "define Device/zn_m2" "$IPQ60XX_MK"; then
        echo "  -> zn_m2 already defined, skipping"
    else
        # Append zn_m2 device definition before the last line
        cat >> "$IPQ60XX_MK" << 'DEVICE_DEF'

define Device/zn_m2
	$(call Device/FitImage)
	$(call Device/UbiFit)
	DEVICE_VENDOR := ZN
	DEVICE_MODEL := M2
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	SOC := ipq6000
	DEVICE_DTS_CONFIG := config@cp03-c1
endef
TARGET_DEVICES += zn_m2
DEVICE_DEF
        echo "  -> zn_m2 device definition added"
    fi
else
    echo "  -> ERROR: $IPQ60XX_MK not found!"
    exit 1
fi

# 2. Copy ZN-M2 DTS file to target directory
echo "[2/6] Installing ZN-M2 DTS file..."
DTS_DIR="target/linux/qualcommax/files/arch/arm64/boot/dts/qcom"
DTS_FILE="$DTS_DIR/ipq6000-m2.dts"

# Use absolute path for patches
PATCHES_DIR="$SCRIPT_DIR/patches"
if [ -f "$PATCHES_DIR/ipq6000-m2.dts" ]; then
    mkdir -p "$DTS_DIR"
    cp "$PATCHES_DIR/ipq6000-m2.dts" "$DTS_FILE"
    echo "  -> DTS file installed: $DTS_FILE"
else
    echo "  -> ERROR: patches/ipq6000-m2.dts not found at $PATCHES_DIR"
    ls -la "$PATCHES_DIR" 2>/dev/null || echo "     Patches directory not found!"
    exit 1
fi

# 3. Remove WiFi from DEFAULT_PACKAGES (user doesn't need WiFi)
echo "[3/6] Removing WiFi from DEFAULT_PACKAGES..."
TARGET_MAKEFILE="target/linux/qualcommax/Makefile"

if [ -f "$TARGET_MAKEFILE" ]; then
    # v25.12.1 has: kmod-ath11k-ahb wpad-openssl in DEFAULT_PACKAGES
    sed -i '/^DEFAULT_PACKAGES/s/kmod-ath11k-ahb //g' "$TARGET_MAKEFILE"
    sed -i '/^DEFAULT_PACKAGES/s/wpad-openssl //g' "$TARGET_MAKEFILE"
    echo "  -> WiFi packages removed from DEFAULT_PACKAGES"
    echo "  -> Updated DEFAULT_PACKAGES:"
    grep "DEFAULT_PACKAGES" "$TARGET_MAKEFILE" | head -3
else
    echo "  -> WARNING: $TARGET_MAKEFILE not found!"
fi

# 4. Verify everything is in place
echo "[4/6] Final verification..."
echo ""
echo "  -> ZN-M2 device definition:"
grep -A8 "define Device/zn_m2" "$IPQ60XX_MK" 2>/dev/null || echo "  -> ERROR: zn_m2 not found!"
echo ""
echo "  -> DTS file exists:"
ls -la "$DTS_FILE" 2>/dev/null || echo "  -> ERROR: DTS file not found!"
echo ""
echo "  -> Kernel version:"
grep "KERNEL_PATCHVER" "$TARGET_MAKEFILE" 2>/dev/null || true
echo ""
echo "============================================"
echo " Build Summary"
echo "============================================"
echo " Source:  ImmortalWrt v25.12.1 (STABLE)"
echo " Kernel:  6.12"
echo " Target:  qualcommax/ipq60xx/zn_m2"
echo " WiFi:    DISABLED"
echo "============================================"

echo ""
echo "DIY Part 2 completed successfully."
