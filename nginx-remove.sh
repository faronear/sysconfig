sudo service nginx stop

sudo apt-get remove nginx -y # 可删除除/etc/nginx 配置文件外的所有文件

sudo apt-get autoremove #自动删除安装nginx时安装的依赖包

sudo apt-get --purge remove nginx-common -y
