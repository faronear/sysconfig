echo 'Starting yapi ...'
sudo pm2 start "/faronear/fon/yapi/vendors/server/app.js" --name yapi # sudo it so that pm2 list shows it as root

echo 'Starting https2http proxy ...'
pushd /faronear/fon/yapi.faronear.org
sudo pm2 start ./node_modules/sol.webserver/server.js --name yapi.https2http # sudo it so that pm2 list shows it as root
popd

echo 'Started yapi + https2http successfully!'
