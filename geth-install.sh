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

ARCH=amd64

echo "=== Install geth：[b] for 二进制， [s] for 源代码，[anything else or leave blank] for no change"
read -p ">>> " BINARY_OR_SOURCE
if [ "$BINARY_OR_SOURCE" == 'b' ]
then
  echo "--- 下载二进制 geth (https://geth.ethereum.org/downloads)"
  # mkdir -p ./geth-temp/
  # cd ./geth-temp
  if [ "$VERSION" == '1.10.26' ]
  then
    wget https://gethstore.blob.core.windows.net/builds/geth-linux-$ARCH-$VERSION-e5eb32ac.tar.gz -O geth-linux.tgz
  elif [ "$VERSION" == '1.10.25' ]
  then
    wget https://gethstore.blob.core.windows.net/builds/geth-linux-$ARCH-$VERSION-69568c55.tar.gz -O geth-linux.tgz
  else
    echo "=== please find the download link in https://geth.ethereum.org/downloads"
    read -p ">>> " DOWNLINK
    wget $DOWNLINK -O geth-linux.tgz
  fi
  tar xzf ./geth-linux.tgz # --strip-components 1 ## 去掉tar包中顶级目录，因为顶级目录含有checksum，不方便在下一步进入
  echo "--- 安装到 /usr/local/bin/geth"
  mv ./geth-linux-*/geth /usr/local/bin/
  echo "--- 删除原始文件"
  rm -fr ./geth-linux.tgz ./geth-linux-$ARCH-$VERSION-*/
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
