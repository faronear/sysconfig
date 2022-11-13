curl https://dist.ipfs.tech/kubo/v0.16.0/kubo_v0.16.0_linux-amd64.tar.gz -o kubo.tgz
tar xzf kubo.tgz
cd kubo && sudo bash install.sh
# echo "alias ipfs=`pwd`/kubo/ipfs" >> ~/.bashrc_custom
# alias ipfs=`pwd`/kubo/ipfs