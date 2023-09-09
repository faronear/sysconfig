curl https://get.acme.sh | sh -s email=ssl@faronear.org
## 或者：
# git clone https://github.com/acmesh-official/acme.sh.git
# cd ./acme.sh
# ./acme.sh --install -m my@example.com

pushd /faronear/sysconfig
# 取消被默认添加到 .bashrc 的设置
git reset . && git checkout .
# echo '. "$HOME/.acme.sh/acme.sh.env"' >> ~/.bashrc_custom ## already integrated in .bashrc
popd
