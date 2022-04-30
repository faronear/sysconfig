# https://docs.docker.com/engine/install/debian/

sudo apt-get update

sudo apt-get install ca-certificates curl gnupg lsb-release -y

read -p "Choose docker source (a: 阿里云, z: 中科大) >>" DOCKER_SOURCE
if [ $DOCKER_SOURCE = 'a' ]
then
  GPG_URL=http://mirrors.aliyun.com/docker-ce/linux/debian/gpg
  DOCKER_URL=http://mirrors.aliyun.com/docker-ce/linux/debian
  COMPOSE_URL=https://get.daocloud.io/docker/compose/releases/download/1.29.2/
elif [ $DOCKER_SOURCE = 'b' ]
then
  GPG_URL=https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg
  DOCKER_URL=https://mirrors.ustc.edu.cn/docker-ce/linux/debian
  COMPOSE_URL=https://get.daocloud.io/docker/compose/releases/download/1.29.2/
else
  GPG_URL=https://download.docker.com/linux/debian/gpg
  DOCKER_URL=https://download.docker.com/linux/debian
  COMPOSE_URL=https://github.com/docker/compose/releases/download/1.29.2/
fi

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
