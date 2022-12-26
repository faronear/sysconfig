curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

pushd /faronear/fon/sysconfig
# 取消被默认添加到 .bashrc 的设置，already integrated in .bashrc
git reset . && git checkout .
popd
