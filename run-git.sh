echo 'Starting gogs git service in screen...'
#screen -dmS gogs
#screen -S gogs -X stuff "/root/gogs/gogs web\n"
cd ~/git/
pm2 start -x './gogs/gogs' -n git.gogs -- web
cd ~

echo 'Starting http2https web service in pm2...'
cd ~/git/www
pm2 start server.js --name git.http2https
cd ~/

echo 'Done!'
