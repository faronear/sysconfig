echo "Usage: setup.sh [USER]"
echo "Example: setup.sh alice"

if [ v$1 != v ]
then
  NewUser=$1
else
  read -p "Enter new user name (leave blank for default 'adot')>> " NewUser
  if [ ! $NewUser ]
  then
    echo Use default new user: adot
    NewUser=adot
  fi
fi

echo "<<< Add a new user $NewUser"
useradd $NewUser
# usermod -a -G sudo $NewUser # Add to sudo group
passwd $NewUser
mkdir /home/$NewUser
chown $NewUser:$NewUser /home/$NewUser
chmod 700 /home/$NewUser

# Set default shell in /etc/passwd
# Debian 10 default to /bin/sh
sed -i "s|/home/$NewUser:/bin/sh$|/home/$NewUser:/bin/bash|g" /etc/passwd
# Debian 9 default to empty
sed -i "s|/home/$NewUser:$|/home/$NewUser:/bin/bash|g" /etc/passwd

echo "<<< Allow the new user $NewUser to sudo without password"
#usermod -a -G sudo $NewUser # Add to sudo group # Option 1: add user to %sudo group
echo "$NewUser ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/${NewUser//./-} # Option 2: add a user file into /etc/sudoers.d/
chmod a-w /etc/sudoers.d/$NewUser
echo

# 注意，在这里为新用户创建的配置文件，主人是 root，而不是新用户
echo "<<< Configure $NewUser home"
source /faronear/fon/sysconfig/home-config.sh /faronear/fon/sysconfig/nixhome /home/$NewUser
echo
