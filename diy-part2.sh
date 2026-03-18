#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# 1. 建立目錄
CORE_DIR="package/feeds/openclash/luci-app-openclash/root/etc/openclash/core"
mkdir -p $CORE_DIR

# 2. 獲取版本號（加入重試，防止 API 解析失敗）
echo "正在獲取 Mihomo 最新版本號..."
for i in {1..5}; do
    CORE_VER=$(curl -s https://api.github.com | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    [ -n "$CORE_VER" ] && break
    echo "獲取失敗，第 $i 次重試..."
    sleep 3
done

if [ -z "$CORE_VER" ]; then
    echo "無法獲取版本號，改用預設版本 v1.18.0"
    CORE_VER="v1.18.0"
fi

# 3. 下載內核（使用 GitHub 代理鏡像以提高穩定性）
# 這裡使用了鏡像地址：https://ghproxy.com (或 https://mirror.ghproxy.com)
DOWNLOAD_URL="https://github.com{CORE_VER}/mihomo-linux-amd64-${CORE_VER}.gz"
MIRROR_URL="https://ghproxy.com${DOWNLOAD_URL}"

echo "正在從鏡像下載內核: $CORE_VER"
curl -fL -o /tmp/clash_meta.gz "$MIRROR_URL" || curl -fL -o /tmp/clash_meta.gz "$DOWNLOAD_URL"

# 4. 驗證文件是否存在並處理
if [ -f "/tmp/clash_meta.gz" ]; then
    gzip -d /tmp/clash_meta.gz
    mv /tmp/clash_meta "$CORE_DIR/clash_meta"
    chmod +x "$CORE_DIR/clash_meta"
    echo "✓ Mihomo (Meta) 內核集成成功"
else
    echo "❌ 內核下載失敗，請檢查 GitHub 網路連接"
    exit 1
fi

# Modify default IP
sed -i 's/192.168.1.1/192.168.6.9/g' package/base-files/files/bin/config_generate
