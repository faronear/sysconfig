curl https://get.acme.sh | sh -s email=ssl@faronear.org

pushd /faronear/fon/sysconfig
# 取消被默认添加到 .bashrc 的设置
git reset . && git checkout .
# echo '. "$HOME/.acme.sh/acme.sh.env"' >> ~/.bashrc_custom ## already integrated in .bashrc
popd
