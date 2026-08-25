echo '::*** Starting gitea ...'
cd /faronear/git/gitea
pm2 start -x './gitea' --name gitea -- web

echo '::*** Started gitea.'
