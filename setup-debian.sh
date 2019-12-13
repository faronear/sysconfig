echo "Usage: setup.sh [USER]"
echo "Example: setup.sh alice"

if [ v$1 != v ]
then
  export User=$1
else
  export User=adot
fi

apt update
apt install -y emacs git curl screen sudo automake

echo ">>> Making dir /faronear"
if [ ! -d "/faronear" ]
then
  mkdir /faronear
fi 
echo ">>> Making dir /faronear/lib"
if [ ! -d "/faronear/lib" ]
then 
  mkdir /faronear/lib
fi
echo ">>> Git cloning to /faronear/lib/sysconfig"
if [ ! -d "/faronear/lib/sysconfig" ]
then
  git clone https://git.faronear.org/lib/sysconfig /faronear/lib/sysconfig
fi
echo ">>> Configure home"
if [ ! -f "~/.bashrc.backup" ]
then
  . /faronear/lib/sysconfig/setup-home.sh
fi

echo ">>> Change root password"
passwd

echo ">>> Add a new user"
useradd $User
# usermod -a -G sudo $User # Add to sudo group
passwd $User
mkdir /home/$User
chown $User:$User /home/$User
# emacs /etc/passwd
# Debian 10 default to /bin/sh
sed -i "s/\/home\/$User:\/bin\/sh$/\/home\/$User:\/bin\/bash/g" /etc/passwd
# Debian 9 default to empty
sed -i "s/\/home\/$User:$/\/home\/$User:\/bin\/bash/g" /etc/passwd

echo ">>> Allow sudo without password: %sudo ALL=(ALL:ALL) NOPASSWD:ALL"
chmod o+w /etc/sudoers
# emacs /etc/sudoers
sed -i "s/%sudo\s\+ALL=(ALL:ALL)\sALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers
chmod o-w /etc/sudoers

echo ">>> Disallow root login: #PermitRootLogin yes"
# emacs /etc/ssh/sshd_config
sed -i "s/^PermitRootLogin yes/#PermitRootLogin yes/g" /etc/ssh/sshd_config
service sshd restart

echo ">>> Configure autostart"
if [ -f /etc/rc.local ]
then
  mv /etc/rc.local /etc/rc.local.backup
fi
touch /etc/rc.local
chmod +x /etc/rc.local
echo '#!/bin/bash' > /etc/rc.local # can't omit, otherwise you can't launch pm2 in autostart.sh. Don't use double quote here, otherwise error.
echo 'source /faronear/autostart.sh' >> /etc/rc.local # make sure to sudo pm2 in autostart.sh, otherwise pm2 list can't find it as root.
touch /faronear/autostart.sh
chmod +x /faronear/autostart.sh
echo '<<< Autostart is set. You can "systemctl start/stop/status rc-local" to manage it.'

echo ">>> Configure locales: install all-locales, default to zh-CN.UTF-8"
dpkg-reconfigure locales

echo "系统设置完毕。"
echo "远程服务器使用策略："
echo "* 统一使用 debian 系统。"
echo "* 禁止 root 用户远程登录，另建 adot (admin+root) 用户用于远程登录。"
echo "* 软件、配置安装在 /faronear 目录下，尽量保持与 git 仓库的路径一致，例如 /faronear/tic/wallet/dist/"
echo "* /faronear 允许 adot 访问，但必须把其中机密文件的权限设置到最小。"
echo "* 用 adot 账号远程登录后，su 后启动软件。"
