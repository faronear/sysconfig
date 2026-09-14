
if [ "$(uname)" = "Darwin" ]
then
  CONFIG_FILE=~/.orbstack/config/docker.json
elif [ -f /etc/debian_version ]
then
  CONFIG_FILE=/etc/docker/daemon.json
else
  echo "Unsupported platform"
  exit 0
fi

echo 'Current config:'
cat $CONFIG_FILE
echo

echo "::*** Enter [y] to 配置中国加速镜像源 $CONFIG_FILE, [anything else] for no change."
read -p "***:: "  DOCKER_MIRROR
if [ "$DOCKER_MIRROR" = 'y' ]
then
  echo '{  "registry-mirrors": [' > $CONFIG_FILE
  echo '  "https://docker.m.daocloud.io",' >> $CONFIG_FILE
  echo '  "https://registry.docker-cn.com",' >> $CONFIG_FILE
  echo '  "http://hub-mirror.c.163.com",' >> $CONFIG_FILE
  echo '  "https://docker.mirrors.ustc.edu.cn",' >> $CONFIG_FILE
  echo '  "https://mirror.ccs.tencentyun.com",' >> $CONFIG_FILE
  echo '  "https://ung2thfc.mirror.aliyuncs.com"' >> $CONFIG_FILE
  echo '] }' >> $CONFIG_FILE
  echo 'Docker mirror in China is configured'
fi
