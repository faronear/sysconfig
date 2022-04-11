# https://docs.docker.com/engine/install/debian/

sudo apt-get update

sudo apt-get install ca-certificates curl gnupg lsb-release -y

echo Add Docker’s official GPG key ...
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo Setup stable repository for Docker ...
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo Install Docker Engine ...
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo Install Docker-Compose ...
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
