echo '>>>> Starting gitea ...'
pushd /faronear/git/gitea
# sudo it so that pm2 list shows it as root
sudo pm2 start -x './gitea' --name gitea -- web
popd

echo '>>>> Started gitea successfully!'
