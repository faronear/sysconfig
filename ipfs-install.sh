defaultVERSION=0.17.0

if [ $1 ]
then
  VERSION=$1
else
  echo "=== Enter kubo <VERSION> or <leave blank> for default $defaultVERSION" 
  read -p ">>> " VERSION
  if [ ! $VERSION ]
  then
    VERSION=$defaultVERSION
    echo Use default version $defaultVERSION
  fi
fi

curl https://dist.ipfs.tech/kubo/v$VERSION/kubo_v$VERSION_linux-amd64.tar.gz -o kubo_v$VERSION.tgz
tar xzf kubo_v$VERSION.tgz
## install ./kubo/ipfs to /usr/local/bin/ipfs
cd kubo && sudo bash install.sh

# echo "alias ipfs=`pwd`/kubo/ipfs" >> ~/.bashrc_custom
# alias ipfs=`pwd`/kubo/ipfs
