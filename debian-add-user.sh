echo "Usage: setup.sh [USER]"
echo "Example: setup.sh alice"
echo

NewUser=$1
while [ ! "$NewUser" ]
do
  echo "=== To add a new user of name:"
  read -p ">>> " NewUser
done

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

echo "=== Allow the new user [$NewUser] to sudo without password? <y> for yes, <anything else> for no"
read -p ">>> " AllowSudo
if [ "$AllowSudo" == "y" ]
then
  #usermod -a -G sudo $NewUser # Add to sudo group # Option 1: add user to %sudo group
  echo "$NewUser ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/${NewUser//./-} # Option 2: add a user file into /etc/sudoers.d/
  chmod a-w /etc/sudoers.d/${NewUser//./-}
  echo "Added /etc/sudoers.d/${NewUser//./-} to allow sudo without password"
else
  echo "--- Nothing changed."
fi
echo

SCRIPTHOME0=/faronear/sysconfig
SCRIPTHOME1=/faronear/fon/sysconfig
SCRIPTHOME2=~/faronear/fon/sysconfig
SCRIPTHOME3=~/faronear/fon.git/sysconfig
SCRIPTHOME4=~/faronear.git/fon.git/sysconfig

if [ -d $SCRIPTHOME0 ]
then
  SCRIPTHOME=$0
elif [ -d $SCRIPTHOME1 ]
then 
  SCRIPTHOME=$SCRIPTHOME1
elif [ -d $SCRIPTHOME2 ]
then
  SCRIPTHOME=$SCRIPTHOME2
elif [ -d $SCRIPTHOME3 ]
then
  SCRIPTHOME=$SCRIPTHOME3
elif [ -d $SCRIPTHOME4 ]
then
  SCRIPTHOME=$SCRIPTHOME4
elif [ -d $SCRIPTHOME5 ]
then
  SCRIPTHOME=$SCRIPTHOME5
else
  echo "=== Enter [script path] or leave [blank] to exit"
  read -p ">>> " SCRIPTHOME
  echo ""
  if [ ! -d "$SCRIPTHOME" ]
  then 
    echo "*** nixhome path [$SCRIPTHOME] not available! Exit now. ***"
    exit
  fi
fi

echo "=== Configure $NewUser's home with standard scripts? <y> for yes, <anything else> for no"
read -p ">>> " ConfigHome
if [ "$ConfigHome" == 'y' ]
then
  source $SCRIPTHOME/home-config.sh $SCRIPTHOME/nixhome $NewUser
else
  echo "--- Nothing configured."
fi
