#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 严格模式：在出错时立即退出，禁止使用未定义的变量
set -euo pipefail

# 错误处理函数
error_exit() {
    echo "❌ Error: $1" >&2
    exit 1
}

# 成功提示函数
success_msg() {
    echo "✅ $1"
}

# 检查 feeds.conf.default 是否存在
if [[ ! -f feeds.conf.default ]]; then
    error_exit "feeds.conf.default not found in current directory"
fi

# 备份原始文件（用于调试和恢复）
if ! cp feeds.conf.default feeds.conf.default.backup; then
    error_exit "Failed to backup feeds.conf.default"
fi

# 使用追加方式添加新 feed（推荐方式）
# 这样避免了 sed 行号变化的问题

# 添加 flrz feed
echo "src-git flrz https://github.com/flrz/openwrt-packages" >> feeds.conf.default && \
    success_msg "Added flrz feed source" || \
    error_exit "Failed to add flrz feed source"

# 添加 OpenClash feed
echo "src-git openclash https://github.com/vernesong/OpenClash" >> feeds.conf.default && \
    success_msg "Added OpenClash feed source" || \
    error_exit "Failed to add OpenClash feed source"

# 可选：添加其他流行的 feed
# echo "src-git helloworld https://github.com/fw876/helloworld.git" >> feeds.conf.default
# echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> feeds.conf.default

# 显示最终的 feeds 配置
echo ""
echo "=========================================="
echo "Final feeds configuration:"
echo "=========================================="
cat feeds.conf.default
echo "=========================================="

success_msg "DIY Part1 completed successfully"


