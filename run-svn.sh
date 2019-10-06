# 不能用 PM2 启动，会报错端口号被占用。可能因为svnserve本身就已经是服务。
svnserve -d -r ./svn.repo
