curl https://get.acme.sh | sh -s email=ssl@faronear.org
## 或者：
# git clone https://github.com/acmesh-official/acme.sh.git .acme.sh
# cd .acme.sh
# ./acme.sh --install -m my@example.com

pushd /faronear/sysconfig
# 取消被默认添加到 .bashrc 的设置，因为 already integrated in .bashrc
git reset . && git checkout .
popd
