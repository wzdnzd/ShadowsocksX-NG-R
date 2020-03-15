#!/bin/sh

#  install_ss_local.sh
#  ShadowsocksX-NG
#
#  Created by 邱宇舟 on 16/6/6.
#  Copyright © 2016年 qiuyuzhou. All rights reserved.


set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

NGDir="$HOME/Library/Application Support/ShadowsocksX-NG-R8"
TargetDir="$NGDir/ss-local-3.3.4"

echo ngdir: ${NGDir}

# 3.2.5 https://bintray.com/homebrew/bottles/shadowsocks-libev/
mkdir -p "$TargetDir"
cp -f ss-local "$TargetDir"
ln -sfh "$TargetDir/ss-local" "$NGDir/ss-local"

cp -f libev.4.dylib "$NGDir"

# 2.8.0 https://bintray.com/homebrew/bottles/mbedtls
cp -f libmbedcrypto.2.16.5.dylib "$NGDir"
ln -sfh  "$NGDir/libmbedcrypto.2.16.5.dylib" "$NGDir/libmbedcrypto.2.dylib"
ln -sfh  "$NGDir/libmbedcrypto.2.16.5.dylib" "$NGDir/libmbedcrypto.3.dylib"

# 8.42 https://bintray.com/homebrew/bottles/pcre
cp -f libpcre.1.dylib "$NGDir"

# 1.0.18 https://bintray.com/homebrew/bottles/libsodium
cp -f libsodium.23.dylib "$NGDir"
ln -sfh "$NGDir/libsodium.23.dylib" "$NGDir/libsodium.dylib"

# 1.15.0 https://bintray.com/homebrew/bottles/c-ares
cp -f libcares.2.dylib "$NGDir"
ln -sfh "$NGDir/libcares.2.dylib" "$NGDir/libcares.dylib"

echo done
