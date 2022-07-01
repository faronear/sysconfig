#!/bin/bash

# https://docs.docker.com/engine/install/debian/


# 安装自带版本 apt install docker.io && apt install docker-compose

echo "=== Choose docker source (a: 阿里云, z: 中科大, leave blank for default):" 
read -p ">>> " DOCKER_SOURCE
if [ $DOCKER_SOURCE = 'a' ]
then
  GPG_URL=http://mirrors.aliyun.com/docker-ce/linux/debian/gpg
  DOCKER_URL=http://mirrors.aliyun.com/docker-ce/linux/debian
  COMPOSE_URL=https://get.daocloud.io/docker/compose/releases/download/1.29.2/
elif [ $DOCKER_SOURCE = 'z' ]
then
  GPG_URL=https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg
  DOCKER_URL=https://mirrors.ustc.edu.cn/docker-ce/linux/debian
  COMPOSE_URL=https://get.daocloud.io/docker/compose/releases/download/1.29.2/
else
  GPG_URL=https://download.docker.com/linux/debian/gpg
  DOCKER_URL=https://download.docker.com/linux/debian
  COMPOSE_URL=https://github.com/docker/compose/releases/download/1.29.2/
fi

echo Prepare environment ...
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y

echo Add Docker’s official GPG key ...
sudo curl -fsSL $GPG_URL | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo Setup stable repository for Docker ...
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $DOCKER_URL $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo Install Docker Engine ...
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo Install Docker-Compose ...
sudo curl -L $COMPOSE_URL/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== 配置中国加速镜像源 /etc/docker/daemon.json (d: Docker中国, t: 腾讯云, z: 中科大, leave blank for no mirror):"
read -p ">>> "  DOCKER_MIRROR
if [ ! $DOCKER_MIRROR ]
then
  echo "--- Docker mirror is not specified."
elif [ $DOCKER_MIRROR = 'd' ]
then
  DOCKER_MIRROR=https://registry.docker-cn.com
elif [ $DOCKER_MIRROR = 't' ]
then
  DOCKER_MIRROR=https://mirror.ccs.tencentyun.com
elif [ $DOCKER_MIRROR = 'z' ]
then
  DOCKER_MIRROR=https://docker.mirrors.ustc.edu.cn
fi

if [ $DOCKER_MIRROR ]
then
  echo "{" | sudo tee /etc/docker/daemon.json > /dev/null
  echo "  \"registry-mirrors\": [" | sudo tee -a /etc/docker/daemon.json > /dev/null
  echo "    \"$DOCKER_MIRROR\"" | sudo tee -a /etc/docker/daemon.json > /dev/null
  echo "  ]" | sudo tee -a /etc/docker/daemon.json > /dev/null
  echo "}" | sudo tee -a /etc/docker/daemon.json > /dev/null
fi

echo "=== 启动docker服务？y for yes, anything else for no"
read -p ">>> " StartDockerDaemon
if [ $StartDockerDaemon ] && [ $StartDockerDaemon = 'y' ]
then
  # 开机启动
  sudo systemctl enable docker
  # 当前启动
  sudo systemctl start docker
fi
