echo '>>>> Starting gitea ...'
cd /faronear/git/gitea
# sudo it so that pm2 list shows it as root
sudo pm2 start -x './gitea' --name gitea -- web

echo '>>>> Started gitea.'
