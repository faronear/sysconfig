#!/bin/bash

if [ $1 ]
then
  VERSION=$1
else
  echo "::*** Install geth version of \n [version number] for example 1.10.26 \n [leave blank] for the latest version"
  read -p "***:: " VERSION
fi

if [ "$(uname)" = "Linux" ]
then
  ARCH=`dpkg --print-architecture`
else
  if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ] # on MacBook Air M2, $(uname -m) returns 'arm64'
  then
    ARCH=arm64
  elif [ "$(uname -m)" = "armv7l" ]
  then
    ARCH=arm
  elif [ "$(uname -m)" = "x86_64" ]
  then
    ARCH=amd64
  fi
fi

OS=`uname | tr 'A-Z' 'a-z'`

echo "::*** Install geth：[b] 二进制， [s] 源代码，[anything else] for no change"
read -p "***:: " BINARY_OR_SOURCE
if [ "$BINARY_OR_SOURCE" == 'b' ]
then
  echo "--- Extracting download link with correct hash from https://geth.ethereum.org/downloads"
  if [ "$VERSION" != '' ]
  then
    wget https://gethstore.blob.core.windows.net/builds/`curl -s -L -o - 'https://geth.ethereum.org/downloads' | grep -o -m 1 "geth-$OS-$ARCH-$VERSION-[0-9a-f]*.tar.gz" | head -n 1` -O geth-binary-temp.tgz
  else
    wget https://gethstore.blob.core.windows.net/builds/`curl -s -L -o - 'https://geth.ethereum.org/downloads' | grep -o -m 1 "geth-$OS-$ARCH-[0-9.]*-[0-9a-f]*.tar.gz" | head -n 1` -O geth-binary-temp.tgz
  fi
  tar xzf ./geth-binary-temp.tgz # --strip-components 1 ## 去掉tar包中顶级目录，因为顶级目录含有checksum，不方便在下一步进入
  echo "--- 安装到 /usr/local/bin/geth"
  sudo mv ./geth-$OS-$ARCH-*/geth /usr/local/bin/
  echo "--- 删除原始文件"
  rm -fr ./geth-binary-temp.tgz ./geth-$OS-$ARCH-*/
elif [ "$BINARY_OR_SOURCE" == 's' ]
then
  echo "--- 克隆并编译 geth"
  mkdir -p ./geth-source-$VERSION/
  git clone -b v$VERSION https://github.com/ethereum/go-ethereum ./geth-source-$VERSION/go-ethereum
  pushd ./geth-source-$VERSION/go-ethereum && make geth && popd # 或者 make all
  sudo mv ./geth-source-$VERSION/go-ethereum/build/bin/geth /usr/local/bin/
  rm -fr ./geth-source-$VERSION/
else
  echo "--- Nothing changed."
fi
echo ""
