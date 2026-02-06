## 这应该是一次性即可，然后在 Admin Console 网页里这个 exit node 上就不会有警告标记。但实际上即使有警告也能用做 exit node。
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf

sudo tailscale up --advertise-exit-node
