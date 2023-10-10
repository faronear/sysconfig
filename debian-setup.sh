#!/bin/bash

echo "Usage: this.sh [NewUser]"
echo "Example: this.sh alice"
echo "curl https://git.faronear.org/npm/sysconfig/raw/branch/main/debian-setup.sh -o ~/debian-setup.sh && bash ~/debian-setup.sh"

if [ "$1" ]
then
  NewUser=$1
else
  NewUser=adot
fi

echo "=== Installing basic tools"
apt update
apt install -y emacs git wget curl screen sudo automake rsync net-tools dnsutils gcc g++ make python3 jq
# Debian 12.0 has no python package, However the following packages replace it:  python-is-python3 2to3
echo

echo "=== Making dir /faronear/"
mkdir -p /faronear/
echo

echo "=== Git cloning to /faronear/sysconfig"
git config --global credential.helper cache
if [ ! -d "/faronear/sysconfig" ]
then
  git clone https://git.faronear.org/npm/sysconfig /faronear/sysconfig
  chmod -R 755 /faronear # 确保其他用户能够读取 /faronear/sysconfig/nixhome/*
fi
echo

echo "=== Configure root home"
source /faronear/sysconfig/nixhome-config.sh /faronear/sysconfig/nixhome root
echo

echo "=== Change root password? [y] for yes, [anything else] for omit:"
read -p ">>> " ChangeRootPassword
if [ "$ChangeRootPassword" == 'y' ]
then
  passwd
fi
echo 

echo "=== Configure /etc/sudoers to includedir /etc/sudoers.d"
#sed -i "s|%sudo\s\+ALL=(ALL:ALL)\sALL|%sudo\tALL=(ALL:ALL) NOPASSWD:ALL|g" /etc/sudoers  # allow all users in %sudo group to sudo without password
DebianVersionMain=`cat /etc/debian_version | sed -r 's/^([0-9]+)\..*$/\1/'`
if [ "$DebianVersionMain" == '10' ]
then
  chmod o+w /etc/sudoers
  ## Debian 10 上，不存在 includedir，需要自己添加。而 Debian 11.1 上，已经存在 @includedir
  echo >> /etc/sudoers
  echo includedir /etc/sudoers.d >> /etc/sudoers  # allow users in /etc/sudoers.d/ folder to sudo
  echo >> /etc/sudoers
  chmod o-w /etc/sudoers
fi
echo

if [ -e /etc/ssh/sshd_config ]
then
  echo "=== Deny root login: PermitRootLogin no"
  sed -i "s|PermitRootLogin |#PermitRootLogin |g" /etc/ssh/sshd_config && echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
  echo "=== Allow password login: PasswordAuthentication yes"
  sed -i "s|PasswordAuthentication |PasswordAuthentication |g" /etc/ssh/sshd_config && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
  service sshd restart
  echo
fi

echo "=== Set [new hostname] or [leave blank] for no change"
read -p ">>> " NewHostname
if [ $NewHostname ]
then
  sed -i "s|\b`hostname`\b|$NewHostname|g" /etc/hosts # echo "127.0.0.1 $NewHostname" >> /etc/hosts
  hostnamectl set-hostname $NewHostname
else
  echo '--- Nothing changed.'
fi
echo

echo "=== Configure autostart"
if [ -f /etc/rc.local ]
then
  # 在腾讯云的 Debian 11.1 里，/etc/rc.local 第一行是 "#!bin/bash"，应当是错误的。
  sed -i "s|!bin/bash|!/bin/bash|" /etc/rc.local
else
  echo '#!/bin/bash' > /etc/rc.local # can't omit, otherwise you can't launch pm2 in autostart.sh. Don't use double quote here, otherwise error.
  chmod +x /etc/rc.local
fi
echo "# make sure to sudo autostart.sh, otherwise for example pm2 list can't find it as root." >> /etc/rc.local
echo 'sudo bash /faronear/autostart.sh' >> /etc/rc.local
touch /faronear/autostart.sh
chmod +x /faronear/autostart.sh
echo 'Autostart is set to /faronear/autostart.sh. Run "systemctl start/stop/status rc-local" to manage it.'
echo

echo "=== Configure locales: [y] for yes, [anything else] for no change:"
read -p ">>> " ConfigLocales
if [ "$ConfigLocales" == 'y' ]
then
  dpkg-reconfigure locales
fi
echo

echo "=== Add a new user [[$NewUser]]? [y] for yes, [anything else] for no change:"
read -p ">>> " AddNewUser
if [ "$AddNewUser" == 'y' ]
then
  source /faronear/sysconfig/debian-add-user.sh $NewUser
  source /faronear/sysconfig/nixhome-config.sh /faronear/sysconfig/nixhome $NewUser

  echo
  echo "=== Enable xfce autologin [/etc/lightdm/lightdm.conf]: [y] for autologin as [[$NewUser]] or [anything else] for no change:"
  read -p ">>> " XfceAutologin
  if [ "$XfceAutologin" == "y" ]
  then
    sed -i "s/^.*autologin-user=.*$/autologin-user=$NewUser/g" /etc/lightdm/lightdm.conf
    sed -i "s/^.*autologin-user-timeout=.*$/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf
    echo "--- Successfully configured autologin as [[$NewUser]]"
  else
    echo '--- Nothing changed.'
  fi
fi
echo

echo "=== Debian System Setup Completed."
