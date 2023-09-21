echo "Binding ipv6 to Oracle Cloud debian instance after configuring ipv6 (https://sunpma.com/1051.html)"
echo "If it failes, try 'sudo ifconfig' to get the correct nic name, because ubuntu use different names."
echo "If there is no 'ifconfig', run 'sudo apt install net-tools' at first"
echo "You can also reboot to automatically bind ipv6"

if [ `dpkg --print-architecture` = 'arm64']
then 
  sudo dhclient -6 enp0s3
else
  sudo dhclient -6 ens3
if
