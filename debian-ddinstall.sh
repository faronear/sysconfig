read -p "Enter root password (default to 'MoeClub.org') >> " ROOTPWD

read -p "Enter debian version to install (default to 11)>> " DEBIAN_VERSION
if [ -z "${DEBIAN_VERSION}" ]
then
  DEBIAN_VERSION=11
fi

apt-get update
apt-get install -y xz-utils openssl gawk file net-tools wget
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d $DEBIAN_VERSION -v 64 -a -firmware -p "$ROOTPWD" --mirror 'https://mirrors.huaweicloud.com/debian/'