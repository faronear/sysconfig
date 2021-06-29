#!/bin/bash

# seafile 7/8 必须配 python3
sudo apt-get update
sudo apt-get install python3 python3-setuptools python3-pip python3-ldap -y
sudo pip3 install --timeout=3600 Pillow pylibmc captcha jinja2 sqlalchemy==1.3.8 psd-tools django-pylibmc django-simple-captcha

pushd /faronear
sudo mkdir seafile
cd seafile
sudo wget https://seafile-downloads.oss-cn-shanghai.aliyuncs.com/seafile-server_8.0.5_x86-64.tar.gz
sudo tar -xzf seafile-server_*
cd seafile-server_*
sudo ./setup-seafile.sh

sed -i "s/127\.0\.0\.1/0.0.0.0/g" ../conf/gunicorn.conf
./seafile.sh start
./seahub.sh

popd
