apt install curl -y

echo "######## 安装 nvm ############################"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

echo "######## 启用 nvm ############################"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "######## 安装最新版 node #####################"
nvm install node

echo "######## node/npm 安装完毕！##################"
