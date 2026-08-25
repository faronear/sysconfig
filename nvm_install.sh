## 注意，这个安装脚本先会查看 NVM_DIR。如果是从其他用户 `su` 过来的，继承了这个变量 NVM_DIR=/home/原用户/.nvm，导致无法安装在当前 root 用户下。
## 因此要么 `su -` 要么不使用安装脚本，而是直接执行脚本里的真正安装动作，即 git clone
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

## Add these lines to your launch script such as .bashrc :
## '########################################################################'
## 'export NVM_DIR="$HOME/.nvm"'
## '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
## '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
## '########################################################################'

## 取消被默认添加到 .bashrc 的设置（already integrated in nixhome/.bashrc）
# pushd ~/sysconfig
# git reset . && git checkout .
# popd

git clone https://github.com/nvm-sh/nvm.git ~/.nvm

echo
echo '############## If in China, set mirror before nvm install ##############'
echo export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node
echo '########################################################################'
