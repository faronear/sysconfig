#!/bin/bash

# seafile 7/8 requires python3
sudo apt-get update
sudo apt-get install python3 python3-setuptools python3-pip python3-ldap sqlite3 -y
sudo pip3 install --timeout=3600 Pillow pylibmc captcha jinja2 sqlalchemy==1.3.8 psd-tools django-pylibmc django-simple-captcha

pushd /faronear
sudo mkdir seafile
cd seafile
sudo wget https://seafile-downloads.oss-cn-shanghai.aliyuncs.com/seafile-server_8.0.5_x86-64.tar.gz
sudo tar -xzf seafile-server_*
cd seafile-server-*
sudo ./setup-seafile.sh

# don't know why but it must be changed to 0.0.0.0 so that seahub.sh doesn't fail. But sometimes 127.0.0.1 also ok on debian 10 of tencent cloud.
sudo sed -i "s/127\.0\.0\.1/0.0.0.0/g" ../conf/gunicorn.conf.py
sudo ./seafile.sh start
sudo ./seahub.sh start

popd
