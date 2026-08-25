sudo apt install lm-sensors hddtemp psensor -y

sudo sensors-detect

sudo sensors

sudo hddtemp /dev/sdb # run `fdisk -l` to get disk names