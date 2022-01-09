read -p "Enter root password or leave blank for default 'MoeClub.org' >> " ROOTPWD

apt-get update
apt-get install -y xz-utils openssl gawk file net-tools wget
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 11 -v 64 -a -firmware -p "$ROOTPWD" --mirror 'https://mirrors.huaweicloud.com/debian/'