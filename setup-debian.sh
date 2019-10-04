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
emacs /etc/passwd

echo ">>> allow sudo without password: %sudo ALL=(ALL:ALL) NOPASSWD:ALL"
chmod o+w /etc/sudoers
emacs /etc/sudoers
chmod o-w /etc/sudoers

echo ">>> disallow root login: #PermitRootLogin yes"
emacs /etc/ssh/sshd_config
service sshd restart

echo ">>> configure locales: install all-locales, default to zh-CN.UTF-8"
dpkg-reconfigure locales

echo "远程服务器使用策略："
echo "* 统一使用 debian 系统。"
echo "* 禁止 root 用户远程登录，另建 adot 用户用于登录。"
echo "* 管理员用 adot 账号登录后，su 到 /root 目录下安装、设置服务软件。"
