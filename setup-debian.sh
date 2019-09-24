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
usermod -a -G sudo $User
passwd $User
emacs /etc/passwd
mkdir /home/$User
chown $User:$User /home/$User

echo ">>> allow sudo without password: %sudo ALL=(ALL:ALL) NOPASSWD:ALL"
chmod o+w /etc/sudoers
emacs /etc/sudoers
chmod o-w /etc/sudoers

echo ">>> disallow root login: #PermitRootLogin yes"
emacs /etc/ssh/sshd_config
service sshd restart

echo ">>> configure locales: install all-locales, default to zh-CN.UTF-8"
dpkg-reconfigure locales
