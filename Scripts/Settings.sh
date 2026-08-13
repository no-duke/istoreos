#!/bin/bash

# 修改默认主题 - 只在 build 目录下执行
if [[ -d "./feeds/luci/collections" ]]; then
    sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile" 2>/dev/null)
fi

# 修改默认IP地址 - 使用正确的路径
if [[ -f "package/base-files/files/bin/config_generate" ]]; then
    sed -i "s/192\.168\.[0-9]*\.[0-9]*/${WRT_IP:-192.168.1.1}/g" package/base-files/files/bin/config_generate
fi

# 修改默认主机名
if [[ -f "package/base-files/files/bin/config_generate" ]]; then
    sed -i "s/hostname='.*'/hostname='${WRT_NAME:-OpenWrt}'/g" package/base-files/files/bin/config_generate
fi

# 添加通用配置到 .config
cat >> ./.config << 'EOF'
CONFIG_PACKAGE_luci=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-app-opkg=y
CONFIG_PACKAGE_luci-app-firewall=y
EOF

# Qualcomm 平台特殊处理
if [[ "${WRT_TARGET^^}" == *"QUALCOMMAX"* ]]; then
    # 设置 NSS 相关
    echo "CONFIG_FEED_nss_packages=y" >> ./.config
    echo "CONFIG_PACKAGE_kmod-nss-qca=y" >> ./.config
    echo "CONFIG_PACKAGE_qca-nss-ecm=y" >> ./.config
    echo "CONFIG_PACKAGE_luci-app-sqm=y" >> ./.config
fi
