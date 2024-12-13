## https://dist.ipfs.tech/

defaultVERSION=0.22.0

if [ $1 ]
then
  VERSION=$1
else
  echo "#<<< Enter kubo [version number] or [leave blank] for default $defaultVERSION" 
  read -p "#>>> " VERSION
  if [ ! $VERSION ]
  then
    VERSION=$defaultVERSION
  fi
fi

if [ "$(uname)" = "Linux" ]
then
  # 用 dpkg --print-architecture 更直接
  ARCH=`dpkg --print-architecture`
else
  if [ "$(uname -m)" = "aarch64" ]
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

echo Download https://dist.ipfs.tech/kubo/v$VERSION/kubo_v${VERSION}_${OS}-${ARCH}.tar.gz
curl https://dist.ipfs.tech/kubo/v$VERSION/kubo_v${VERSION}_${OS}-${ARCH}.tar.gz -o kubo_v$VERSION.tgz
tar xzf kubo_v$VERSION.tgz
rm -fr kubo_v$VERSION.tgz
## install ./kubo/ipfs to /usr/local/bin/ipfs
cd kubo && sudo bash install.sh
cd .. && rm -fr kubo/

# echo "alias ipfs=`pwd`/kubo/ipfs" >> ~/.bashrc_custom
# alias ipfs=`pwd`/kubo/ipfs
