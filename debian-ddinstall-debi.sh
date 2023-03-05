#!/bin/bash

echo "Thanks https://github.com/bohanyang/debi"
echo

echo "=== Enter debian version [8,9,10,11] or [leave blank] for 11"
read -p ">>> " DEBIAN_VERSION
if [ -z "${DEBIAN_VERSION}" ]
then
  DEBIAN_VERSION=11
fi

echo "=== Enter architecture [amd64, i386, arm64, armhf] or [leave blank] for amd64" 
read -p ">>> " DEBIAN_ARCH
if [ -z "${DEBIAN_ARCH}" ]
then
  DEBIAN_ARCH=amd64
fi

echo "=== Enter presets to download from [cdn, aws, china] or [leave blank] for cdn"
read -p ">>> " PRESET
if [ -z "${PRESET}" ]
then
  PRESET=cdn
fi

sudo curl -fLO https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh
sudo chmod a+rx debi.sh
sudo ./debi.sh --version $DEBIAN_VERSION --architecture $DEBIAN_ARCH --user root --$PRESET # --architecture 可参略，默认为 amd64；--password 可省略，则脚本启动后会问你要密码

echo "=== Shutdown now, wait for about 30 minutes (the project's github says 30 seconds), then try to ssh"
sudo shutdown -r now
