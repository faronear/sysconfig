echo 'Starting gogs git service in screen...'
#screen -dmS gogs
#screen -S gogs -X stuff "/faronear/gogs/gogs web\n"
cd /faronear/git
sudo pm2 start -x './gogs/gogs' -n git.gogs -- web # sudo it so that pm2 list shows it as root
cd /faronear

echo 'Starting http2https web service in pm2...'
cd /faronear/git/git.faronear.org
sudo pm2 start server.js --name git.http # sudo it so that pm2 list shows it as root
cd /faronear

echo 'Done!'
