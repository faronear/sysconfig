echo Installing this package automatically starts and runs Caddy as a systemd service named caddy. It also comes with an optional caddy-api service which is not enabled by default, but should be used if you primarily configure Caddy via its API instead of config files.

sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

echo 
echo Certificates will be saved automatically in ~/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/
echo Config file of caddy started by systemctl : /etc/caddy/Caddyfile

# 202601 注意到 caddy 的 gpg.key 过时了，导致 apt update 报错。更新：
# https://github.com/caddyserver/caddy/issues/7411
# [Solved] Caddy's APT repo (ubuntu/debian) GPG key has expired · Issue #7411 · caddyserver/caddy
# curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
