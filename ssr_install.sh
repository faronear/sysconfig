#!/bin/bash

apt update && apt install -y zip
cd /faronear/
mkdir bin
cd bin
wget https://www.gigsgigscloud.com/cn/downloads/ssr.zip --no-check-certificate
unzip ssr.zip
cd SSR*
bash install.sh

# if [ "$1" ]
# then
#   KEYCODE=$1
# else
#   KEYCODE=44444
# fi
# USERNAME=$KEYCODE
# PORT=$KEYCODE
# PASSWORD=$KEYCODE
# ENCRYPTION=5
# PROTOCOL=4
# OBFS=4
# ORIGINAL_OBFS=n
# QUOTA=1000
# SPEEDLIMIT=n
# echo -e "2\n1\n$USER\n$PORT\n$PASSWORD\$ENCRYPTION\n$PROTOCOL\n\$OBFS\n$ORIGINAL_OBFS\n$QUOTA\n$SPEEDLIMIT\n" | ssr
## 报错，不能这样调用

# [2020-02-13] 以下标准安装脚本无法使用，因为里面调用 http:// 但是现已转为 https://
# wget https://www.gigsgigscloud.com/cn/downloads/ssr.sh --no-check-certificate
# sudo bash ssr.sh
# sudo ssr
