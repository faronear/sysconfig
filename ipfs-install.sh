wget https://dist.ipfs.tech/kubo/v0.16.0/kubo_v0.16.0_linux-amd64.tar.gz
tar xzf https://dist.ipfs.tech/kubo/v0.16.0/kubo_v0.16.0_linux-amd64.tar.gz
cd kubo
echo "alias ipfs=`pwd`/kubo/ipfs" >> ~/.bashrc_custom
alias ipfs=`pwd`/kubo/ipfs