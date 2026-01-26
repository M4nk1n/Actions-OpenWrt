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

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# Turboacc
# 带 sfe:
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
# 不带 sfe:
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh --no-sfe

# Argon theme
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon && \
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# OpenClash
git clone -b master --single-branch --depth=1 https://github.com/vernesong/OpenClash.git package/OpenClash && \
cp -r package/OpenClash/luci-app-openclash package/ && \
rm -rf package/OpenClash

# OpenClash core
mkdir -p files/etc/openclash/core && \
curl -fsSL https://github.com/vernesong/OpenClash/raw/refs/heads/core/master/meta/clash-linux-amd64-v2.tar.gz | tar xvzf - -C files/etc/openclash/core && \
mv files/etc/openclash/core/clash files/etc/openclash/core/clash_meta && \
chmod +x files/etc/openclash/core/clash_meta

# AdGuardHome
mkdir kwrt-packages && \
cd kwrt-packages && \
git init && \
git remote add origin https://github.com/kiddin9/kwrt-packages.git && \
git config core.sparsecheckout true && \
echo "luci-app-adguardhome" >> .git/info/sparse-checkout && \
git pull --depth 1 origin main && \
git branch --set-upstream-to=origin/main master && \
cd .. && \
cp -r kwrt-packages/luci-app-adguardhome package/luci-app-adguardhome && \
rm -rf kwrt-packages

# dnsmasq-full
sed -i "s/dnsmasq/dnsmasq-full/g" include/target.mk
sed -i "/odhcp6c/d" include/target.mk
sed -i "/odhcpd-ipv6only/d" include/target.mk
