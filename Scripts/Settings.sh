#!/bin/bash

# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")

# 修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/${WRT_IP}/g" package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i "s/hostname='.*'/hostname='${WRT_NAME}'/g" package/base-files/files/bin/config_generate

# 添加通用配置
echo "CONFIG_PACKAGE_luci=y" >> ./.config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-argon-config=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-opkg=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-firewall=y" >> ./.config

# Qualcomm 平台特殊处理
if [[ "${WRT_TARGET^^}" == *"QUALCOMMAX"* ]]; then
    # 设置 NSS 相关
    echo "CONFIG_FEED_nss_packages=y" >> ./.config
    echo "CONFIG_PACKAGE_kmod-nss-qca=y" >> ./.config
    echo "CONFIG_PACKAGE_qca-nss-ecm=y" >> ./.config
    echo "CONFIG_PACKAGE_luci-app-sqm=y" >> ./.config
fi
