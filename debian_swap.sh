# 1. 创建 2G swap 文件
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
    
# 2. 开机自动挂载
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    
# 3. 降低 swap 倾向（内存紧张才用 swap，平时不影响性能）
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99 -swap.conf
sudo sysctl -p /etc/sysctl.d/99-swap.conf
    
# 4. 确认
free -h
