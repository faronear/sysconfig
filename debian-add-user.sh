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

testpath0=/faronear/sysconfig
testpath1=/faronear/fon/sysconfig
testpath2=~/faronear/fon/sysconfig
testpath3=~/faronear/fon.git/sysconfig
testpath4=~/faronear.git/fon.git/sysconfig

if [ -d $testpath0 ]
then
  SourcePath=$1
elif [ -d $testpath1 ]
then 
  SourcePath=$testpath1
elif [ -d $testpath2 ]
then
  SourcePath=$testpath2
elif [ -d $testpath3 ]
then
  SourcePath=$testpath3
elif [ -d $testpath4 ]
then
  SourcePath=$testpath4
elif [ -d $testpath5 ]
then
  SourcePath=$testpath5
else
  echo "=== Enter [nixhome path] or leave [blank] to exit"
  read -p ">>> " SourcePath
  echo ""
  if [ ! -d "$SourcePath" ]
  then 
    echo "*** nixhome path [$SourcePath] not available! Exit now. ***"
    exit
  fi
fi

echo "=== Configure $NewUser's home with standard scripts? <y> for yes, <anything else> for no"
read -p ">>> " ConfigHome
if [ "$ConfigHome" == 'y' ]
then
  source $SourcePath/home-config.sh $SourcePath/nixhome $NewUser
else
  echo "--- Nothing configured."
fi
