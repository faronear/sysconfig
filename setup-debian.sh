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

echo ">>> Change root password"
passwd

echo ">>> add a new user"
useradd $User
# usermod -a -G sudo $User # 不允许登录账号进行 sudo 来访问关键资源
passwd $User
mkdir /home/$User
chown $User:$User /home/$User
# emacs /etc/passwd
sed -i "s/\/home\/$User:/\/home\/$User:\/bin\/bash/g" /etc/passwd

echo ">>> allow sudo without password: %sudo ALL=(ALL:ALL) NOPASSWD:ALL"
chmod o+w /etc/sudoers
# emacs /etc/sudoers
sed -i "s/%sudo\s\+ALL=(ALL:ALL)\sALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers
chmod o-w /etc/sudoers

echo ">>> disallow root login: #PermitRootLogin yes"
sed -i "s/^PermitRootLogin yes/#PermitRootLogin yes/g" /etc/ssh/sshd_config
# emacs /etc/ssh/sshd_config
service sshd restart

echo ">>> config autostart"
mv /etc/rc.local /etc/rc.local.backup
touch /etc/rc.local
chmod +x /etc/rc.local
echo '#!/bin/bash' > /etc/rc.local # can't omit, otherwise you can't launch pm2 in autostart.sh. Don't use double quote here, otherwise error.
echo 'source /root/autostart.sh' >> /etc/rc.local # make sure to sudo pm2 in autostart.sh, otherwise pm2 list can't find it as root.
touch /root/autostart.sh
chmod +x /root/autostart.sh
echo '<<< autostart is set. You can "systemctl start/stop/status rc-local" to manage it.'

echo ">>> configure locales: install all-locales, default to zh-CN.UTF-8"
dpkg-reconfigure locales

echo "远程服务器使用策略："
echo "* 统一使用 debian 系统。"
echo "* 禁止 root 用户远程登录，另建 adot 用户用于登录。"
echo "* 管理员用 adot 账号登录后，su 到 /root 目录下安装、设置服务软件。"
