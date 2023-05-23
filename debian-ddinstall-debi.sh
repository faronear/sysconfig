#!/bin/bash

echo "Thanks https://github.com/bohanyang/debi"
echo

echo "=== Enter debian version [8,9,10,11] or [leave blank] for 11"
read -p ">>> " DEBIAN_VERSION
if [ -z "${DEBIAN_VERSION}" ]
then
  DEBIAN_VERSION=11
fi

# 用 dpkg --print-architecture 更直接
ARCH=`dpkg --print-architecture`
# if [[ "$(uname -m)" = "aarch64" ]];
# then
#   ARCH=arm64
# elif [[ "$(uname -m)" = "armv7l" ]];
# then
#   ARCH=arm
# elif [[ "$(uname -m)" = "x86_64" ]];
# then
#   ARCH=amd64
# fi

echo "=== Enter presets to download from [cdn, aws, china] or [leave blank] for cdn"
read -p ">>> " PRESET
if [ -z "${PRESET}" ]
then
  PRESET=cdn
fi

sudo curl -fLO https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh
sudo chmod a+rx debi.sh
sudo ./debi.sh --version $DEBIAN_VERSION --architecture `dpkg --print-architecture` --user root --$PRESET # --architecture 可参略或者[amd64（默认）, i386, arm64, armhf]；--password 可省略，则脚本启动后会问你要密码

echo
echo "=== Last chance!!! Enter [r] to reboot to new system, or [anything else] to cancel all changes"
read -p ">>> " LAST
if [ 'r' = "$LAST" ]
then 
  echo "=== Shutdown now, wait for about 30 minutes (the project's github says 30 seconds), then try to ssh"
  sudo shutdown -r now
else
  sudo rm -rf debi.sh /etc/default/grub.d/zz-debi.cfg /boot/debian-* && { sudo update-grub || sudo grub2-mkconfig -o /boot/grub2/grub.cfg; }
fi
