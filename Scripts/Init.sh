#!/bin/bash

# ZN-M2 设备特殊设置
if [[ "${WRT_CONFIG,,}" == *"zn-m2"* ]]; then
    # ZN-M2 使用 192.168.12.1
    WRT_IP="192.168.12.1"
fi

# 如果没有设置 IP，使用默认值
WRT_IP="${WRT_IP:-192.168.1.1}"
WRT_NAME="${WRT_NAME:-OpenWrt}"
