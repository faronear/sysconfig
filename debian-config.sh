#!/bin/bash

echo "Usage: this.sh [NewUser]"
echo "Example: this.sh alice"

if [ v$1 != v ]
then
  NewUser=$1
else
  NewUser=adot
fi

echo "<<< Installing basic tools"
apt update
apt install -y emacs git curl screen sudo automake rsync
echo

echo "<<< Making dir /faronear"
if [ ! -d "/faronear" ]
then
  mkdir /faronear
fi 
echo

echo "<<< Making dir /faronear/fon"
if [ ! -d "/faronear/fon" ]
then 
  mkdir /faronear/fon
fi
echo

echo "<<< Git cloning to /faronear/fon/sysconfig"
git config --global credential.helper cache
if [ ! -d "/faronear/fon/sysconfig" ]
then
  git clone https://git.faronear.org/fon/sysconfig /faronear/fon/sysconfig
fi
echo

echo "<<< Configure root home"
source /faronear/fon/sysconfig/home-config.sh /faronear/fon/sysconfig/nixhome
echo

echo "<<< Change root password"
passwd
echo 

echo "<<< Add a new user $NewUser"
useradd $NewUser
passwd $NewUser
mkdir /home/$NewUser
chown $NewUser:$NewUser /home/$NewUser
chmod 700 /home/$NewUser
echo

# 注意，在这里为新用户创建的配置文件，主人是 root.
echo "<<< Configure $NewUser home"
source /faronear/fon/sysconfig/home-config.sh /faronear/fon/sysconfig/nixhome /home/$NewUser
echo

# Debian 10 default to /bin/sh
sed -i "s|/home/$NewUser:/bin/sh$|/home/$NewUser:/bin/bash|g" /etc/passwd
# Debian 9 default to empty
sed -i "s|/home/$NewUser:$|/home/$NewUser:/bin/bash|g" /etc/passwd

echo "<<< Allow the new user $NewUser to sudo without password"
#### Option 1: Add the new user to %sudo group in /etc/sudoers file
#usermod -a -G sudo $NewUser # Add to sudo group
#echo "<<< Allow sudo without password: %sudo ALL=(ALL:ALL) NOPASSWD:ALL"
#chmod o+w /etc/sudoers
#sed -i "s|%sudo\s\+ALL=(ALL:ALL)\sALL|%sudo\tALL=(ALL:ALL) NOPASSWD:ALL|g" /etc/sudoers
#chmod o-w /etc/sudoers
#### Option 2: Add a file for the new user in /etc/sudoers.d/ folder
chmod o+w /etc/sudoers
sed -i "s|#includedir /etc/sudoers.d|includedir /etc/sudoers.d|g" /etc/sudoers
chmod o-w /etc/sudoers
echo "$NewUser ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NewUser
chmod a-w /etc/sudoers.d/$NewUser
echo

echo "<<< Disallow root login: #PermitRootLogin yes"
# emacs /etc/ssh/sshd_config
sed -i "s|^PermitRootLogin yes|#PermitRootLogin yes|g" /etc/ssh/sshd_config
service sshd restart
echo

echo "<<< Set hostname or leave blank for no change"
read -p "hostname = " NewHostname
if [ $NewHostname ]
then
  hostnamectl set-hostname $NewHostname
  echo "127.0.0.1 $NewHostname" >> /etc/hosts
else
  echo 'Nothing changed >>>'
fi
echo

echo "<<< autologin for Xfce: /etc/lightdm/lightdm.conf"
read -p "<<< Enable xfce autologin as ($NewUser for autologin or anything else for no change): " XfceAutologinUsername
if [ $XfceAutologinUsername = $NewUser ]
then
  sed -i "s/^.*autologin-user=.*$/autologin-user=$NewUser/g" /etc/lightdm/lightdm.conf
  sed -i "s/^.*autologin-user-timeout=.*$/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf
  echo "Successfully configured autologin as $NewUser"
else
  echo 'Nothing changed >>>'
fi
echo

echo "<<< Configure autostart"
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
echo 'Autostart is set to /faronear/autostart.sh. Run "systemctl start/stop/status rc-local" to manage it.'
echo

echo "<<< Configure locales: install all-locales and set default to none."
dpkg-reconfigure locales
echo

echo "<<< Debian System Setup Completed >>>"

