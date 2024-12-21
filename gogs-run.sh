# 服务化方案1: screen
#echo '::*** Starting gogs in screen ...'
#screen -dmS gogs
#screen -S gogs -X stuff "/faronear/gogs/gogs web\n"

# 服务化方案2: pm2
echo '::*** Starting gogs in pm2 ...'
cd /faronear/git/gogs # 如果在 /faronear/git 中运行 ./gogs/gogs，导致额外生成 /faronear/git/data 目录。
# sudo it so that pm2 list shows it as root
sudo pm2 start -x './gogs' --name git.gogs -- web
cd /faronear/git

echo '::*** Started gogs.'
