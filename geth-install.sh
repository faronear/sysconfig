#!/bin/bash

defaultVERSION=1.11.2

if [ $1 ]
then
  VERSION=$1
else
  echo "=== Enter geth <VERSION> or <leave blank> for default $defaultVERSION" 
  read -p ">>> " VERSION
  if [ ! "$VERSION" ]
  then
    VERSION=$defaultVERSION
    echo Use default version $defaultVERSION
  fi
fi

# 用 dpkg --print-architecture 更直接
ARCH=`dpkg --print-architecture`
# if [[ "$(uname -m)" = "aarch64" ]];
# then
#   ARCH=arm64
# elif [[ "$(uname -m)" = "armv7l" ]];
# then
#   ARCH=arm
# elif [[ "$(uname -m)" = "x86_64" ]];
# then
#   ARCH=amd64
# fi

OS=`uname | tr 'A-Z' 'a-z'`

echo "=== Install geth：[b] for 二进制， [s] for 源代码，[anything else or leave blank] for no change"
read -p ">>> " BINARY_OR_SOURCE
if [ "$BINARY_OR_SOURCE" == 'b' ]
then
  echo "--- 下载二进制 geth (https://geth.ethereum.org/downloads) with correct hash"
  read -p ">>> " DOWNLINK
  # wget https://gethstore.blob.core.windows.net/builds/geth-$OS-$ARCH-$VERSION-$HASH.tar.gz -O geth-$OS-$ARCH-$VERSION.tgz
  wget $DOWNLINK -O geth-$OS-$ARCH-$VERSION.tgz
  tar xzf ./geth-$OS-$ARCH-$VERSION.tgz # --strip-components 1 ## 去掉tar包中顶级目录，因为顶级目录含有checksum，不方便在下一步进入
  echo "--- 安装到 /usr/local/bin/geth"
  mv ./geth-$OS-$ARCH-$VERSION-*/geth /usr/local/bin/
  echo "--- 删除原始文件"
  rm -fr ./geth-$OS-$ARCH-$VERSION.tgz ./geth-$OS-$ARCH-$VERSION-*/
elif [ "$BINARY_OR_SOURCE" == 's' ]
then
  echo "--- 克隆并编译 geth"
  git clone -b v$VERSION https://github.com/ethereum/go-ethereum ./geth-temp/go-ethereum
  mkdir -p ./geth-temp/
  pushd ./geth-temp/go-ethereum && make geth && popd # 或者 make all
  mv ./geth-temp/go-ethereum/build/bin/geth /usr/local/bin/
  rm -fr ./geth-temp/
else
  echo "--- Nothing changed."
fi
echo ""
