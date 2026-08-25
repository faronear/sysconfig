mkdir /mnt/blockstorage
echo >> /etc/fstab
echo /dev/vdb1               /mnt/blockstorage       ext4    defaults,noatime,nofail 0 0 >> /etc/fstab
mount /mnt/blockstorage
