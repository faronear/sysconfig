echo "Usage: setup.sh [USER]"
echo "Example: setup.sh alice"

if [ v$1 != v ]
then
  NewUser=$1
else
  read -p "Enter new user name: " NewUser
fi

echo "<<< Add a new user $NewUser"
useradd $NewUser
# usermod -a -G sudo $NewUser # Add to sudo group
passwd $NewUser
mkdir /home/$NewUser
chown $NewUser:$NewUser /home/$NewUser
chmod 700 /home/$NewUser
# emacs /etc/passwd
# Debian 10 default to /bin/sh
sed -i "s/\/home\/$NewUser:\/bin\/sh$/\/home\/$NewUser:\/bin\/bash/g" /etc/passwd
# Debian 9 default to empty
sed -i "s/\/home\/$NewUser:$/\/home\/$NewUser:\/bin\/bash/g" /etc/passwd
