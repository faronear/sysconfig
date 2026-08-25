echo Install xfce on WSL2-Debian11/Ubuntu ...
echo 2022-09-14 测试无效！

sudo apt update && sudo apt -y upgrade
sudo apt-get purge xrdp
# install xfce 
sudo apt-get install -y xfce4 xfce4-goodies
# install xrdp
sudo apt-get install xrdp
sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini
echo xfce4-session > ~/.xsession
# install dbus
sudo apt-get install dbus-x11
sudo service dbus start
# because while starting xrdp I got the error 'Failed to execute child process 'dbus-launch'':
# export the correct DBUS_SESSION_BUS_ADDRESS and DBUS_SESSION_BUS_PID
export $(dbus-launch)
# enable dbus
sudo systemctl enable dbus
sudo /etc/init.d/dbus start
sudo /etc/init.d/xrdp start
# check xrdp status
sudo /etc/init.d/xrdp status