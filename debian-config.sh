#!/bin/bash

echo "Usage: this.sh [NewUser]"
echo "Example: this.sh alice"
echo "curl https://git.faronear.org/fon/sysconfig/raw/branch/main/debian-config.sh | sudo bash"

if [ v$1 != v ]
then
  NewUser=$1
else
  NewUser=adot
fi

echo "=== Installing basic tools"
apt update
apt install -y emacs git curl screen sudo automake rsync
echo

echo "=== Making dir /faronear"
if [ ! -d "/faronear" ]
then
  mkdir /faronear
fi 
echo

echo "=== Making dir /faronear/fon"
if [ ! -d "/faronear/fon" ]
then 
  mkdir /faronear/fon
fi
echo

echo "=== Git cloning to /faronear/fon/sysconfig"
git config --global credential.helper cache
if [ ! -d "/faronear/fon/sysconfig" ]
then
  git clone https://git.faronear.org/fon/sysconfig /faronear/fon/sysconfig
fi
echo

echo "=== Configure root home"
source /faronear/fon/sysconfig/home-config.sh /faronear/fon/sysconfig/nixhome
echo

echo "=== Change root password? <y> for yes, anything else for omit:"
read -p ">>> " ChangeRootPassword
if [ "$ChangeRootPassword" == 'y' ]
then
  passwd
fi
echo 

echo "=== Configure /etc/sudoers: includedir /etc/sudoers.d"
chmod o+w /etc/sudoers
#sed -i "s|%sudo\s\+ALL=(ALL:ALL)\sALL|%sudo\tALL=(ALL:ALL) NOPASSWD:ALL|g" /etc/sudoers  # allow all users in %sudo group to sudo without password
sed -i "s|#includedir /etc/sudoers.d|@includedir /etc/sudoers.d|g" /etc/sudoers  # allow users in /etc/sudoers.d/ folder to sudo
chmod o-w /etc/sudoers
echo

echo "=== Disallow root login: #PermitRootLogin yes"
# emacs /etc/ssh/sshd_config
sed -i "s|^PermitRootLogin yes|#PermitRootLogin yes|g" /etc/ssh/sshd_config
service sshd restart
echo

echo "=== Set <hostname> or <leave blank> for no change"
read -p ">>> " NewHostname
if [ $NewHostname ]
then
  sed -i "s|\b`hostname`\b|$NewHostname|g" /etc/hosts # echo "127.0.0.1 $NewHostname" >> /etc/hosts
  hostnamectl set-hostname $NewHostname
else
  echo 'Nothing changed.'
fi
echo

echo "=== Configure autostart"
if [ ! -f /etc/rc.local ]
then
  echo '#!/bin/bash' > /etc/rc.local # can't omit, otherwise you can't launch pm2 in autostart.sh. Don't use double quote here, otherwise error.
fi
chmod +x /etc/rc.local

echo 'source /faronear/autostart.sh' >> /etc/rc.local
touch /faronear/autostart.sh
echo "# make sure to sudo in autostart.sh, otherwise for example pm2 list can't find it as root." >> /faronear/autostart.sh
chmod +x /faronear/autostart.sh
echo 'Autostart is set to /faronear/autostart.sh. Run "systemctl start/stop/status rc-local" to manage it.'
echo

echo "=== Configure locales: install all-locales and set default to none."
dpkg-reconfigure locales
echo

echo "=== Add a new user $NewUser"
source /faronear/fon/sysconfig/debian-add-user.sh $NewUser
echo

echo "=== Enable xfce autologin [/etc/lightdm/lightdm.conf] as user <$NewUser> for autologin or <anything else> for no change):"
read -p ">>> " XfceAutologinUsername
if [ $XfceAutologinUsername = $NewUser ]
then
  sed -i "s/^.*autologin-user=.*$/autologin-user=$NewUser/g" /etc/lightdm/lightdm.conf
  sed -i "s/^.*autologin-user-timeout=.*$/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf
  echo "Successfully configured autologin as $NewUser"
else
  echo 'Nothing changed.'
fi
echo

echo "=== Debian System Setup Completed."
