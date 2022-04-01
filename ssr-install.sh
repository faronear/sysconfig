apt update && apt install -y zip
cd /faronear/
mkdir bin
cd bin
wget https://www.gigsgigscloud.com/cn/downloads/ssr.zip --no-check-certificate
unzip ssr.zip
cd SSR*
bash install.sh

# [2020-02-13] 以下标准安装脚本无法使用，因为里面调用 http:// 但是现已转为 https://
# wget https://www.gigsgigscloud.com/cn/downloads/ssr.sh --no-check-certificate
# sudo bash ssr.sh
# sudo ssr
