echo 'Starting gogs git service in screen...'
#screen -dmS gogs
#screen -S gogs -X stuff "/root/gogs/gogs web\n"
cd /root/git
sudo pm2 start -x './gogs/gogs' -n git.gogs -- web # sudo it so that pm2 list shows it as root
cd /root

echo 'Starting http2https web service in pm2...'
cd /root/git/git.faronear.org
sudo pm2 start server.js --name git.http2https # sudo it so that pm2 list shows it as root
cd /root

echo 'Done!'
