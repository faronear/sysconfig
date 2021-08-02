#!/bin/bash

# seafile 7/8 requires python3
sudo apt-get update
sudo apt-get install python3 python3-setuptools python3-pip python3-ldap sqlite3 -y
sudo pip3 install --timeout=3600 Pillow pylibmc captcha jinja2 sqlalchemy==1.3.8 psd-tools django-pylibmc django-simple-captcha

pushd /faronear
sudo mkdir bin.seafile
cd bin.seafile
sudo wget https://seafile-downloads.oss-cn-shanghai.aliyuncs.com/seafile-server_8.0.6_x86-64.tar.gz
sudo tar -xzf seafile-server_*
cd seafile-server-*
sudo ./setup-seafile.sh

ln -s seafile-server-8.0.6 sea

sudo ./seafile.sh start

# changed "127.0.0.1:8000" to "0.0.0.0:8000", otherwise it can only be accessed on the localhost, unless using nginx/apache to proxy
sudo sed -i "s/127\.0\.0\.1/0.0.0.0/g" ../conf/gunicorn.conf.py
# to change seahub port, to edit gunicorn.conf.py, it works although it still promts "Starting seahub at port 8000 ...". (Directly `./seahub.sh start <PORT>` prompts "Starting seahub at port <PORT> ..." but it actually doesn't listen on <PORT>.)
sudo ./seahub.sh start

popd
