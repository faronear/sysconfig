echo '>>>> Starting http2https in pm2 ...'
cd /faronear/git/git.faronear.org
# sudo it so that pm2 list shows it as root
sudo pm2 start ./node_modules/basend-webserver/server.js --name git.http2https
cd /faronear/git

echo '>>>> Started http2https.'
