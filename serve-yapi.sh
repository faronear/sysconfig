echo 'Starting yapi...'
sudo pm2 start "/root/yapi/vendors/server/app.js" --name yapi # sudo it so that pm2 list shows it as root

echo 'Starting http2https web service...'
cd /root/yapi.faronear.org
sudo pm2 start server.js --name yapi.https2http # sudo it so that pm2 list shows it as root
cd ..

echo 'Done!'
