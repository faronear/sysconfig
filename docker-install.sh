#!/bin/bash

# https://docs.docker.com/engine/install/debian/


# 安装自带版本 apt install docker.io && apt install docker-compose
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "=== Choose docker source: [a] 阿里云, [z] 中科大, [leave blank] for default" 
read -p ">>> " DOCKER_SOURCE
if [ "$DOCKER_SOURCE" = 'a' ]
then
  GPG_URL=http://mirrors.aliyun.com/docker-ce/linux/debian/gpg
  DOCKER_URL=http://mirrors.aliyun.com/docker-ce/linux/debian
#  COMPOSE_URL=https://get.daocloud.io/docker/compose/releases/download/2.20.3/
elif [ "$DOCKER_SOURCE" = 'z' ]
then
  GPG_URL=https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg
  DOCKER_URL=https://mirrors.ustc.edu.cn/docker-ce/linux/debian
#  COMPOSE_URL=https://get.daocloud.io/docker/compose/releases/download/2.20.3/
else
  GPG_URL=https://download.docker.com/linux/debian/gpg
  DOCKER_URL=https://download.docker.com/linux/debian
#  COMPOSE_URL=https://github.com/docker/compose/releases/download/2.20.3/
fi

echo Prepare environment ...
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo apt-get remove docker docker-engine docker.io containerd runc -y

echo Add official GPG key ...
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL $GPG_URL | sudo gpg --dearmor -o /etc/apt/keyrings/docker-archive-keyring.gpg

echo Setup stable repository for Docker ...
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker-archive-keyring.gpg] $DOCKER_URL $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo Install Docker Engine ...
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

docker -v
docker compose version

# 或者手动安装 compose https://docs.docker.com/compose/install/linux/
# echo Install Docker-Compose ...
# sudo curl -L $COMPOSE_URL/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose

echo "=== Enter [y] to 配置中国加速镜像源 /etc/docker/daemon.json, [anything else] for no mirror:"
read -p ">>> "  DOCKER_MIRROR
if [ "$DOCKER_MIRROR" = 'y' ]
then
  echo '{  "registry-mirrors": [' > /etc/docker/daemon.json
  echo '  "https://registry.docker-cn.com",' >> /etc/docker/daemon.json
  echo '  "http://hub-mirror.c.163.com",' >> /etc/docker/daemon.json
  echo '  "https://docker.mirrors.ustc.edu.cn",' >> /etc/docker/daemon.json
  echo '  "https://mirror.ccs.tencentyun.com",' >> /etc/docker/daemon.json
  echo '  "https://ung2thfc.mirror.aliyuncs.com"' >> /etc/docker/daemon.json
  echo '] }' >> /etc/docker/daemon.json
fi

echo "=== 启动docker服务？[y] for yes, [anything else] for no"
read -p ">>> " StartDockerDaemon
if [ "$StartDockerDaemon" = 'y' ]
then
  sudo systemctl enable docker # 开机启动
  sudo systemctl start docker # 当前启动
  sudo docker info # 查看状态，例如 'Registry Mirros:'
fi
