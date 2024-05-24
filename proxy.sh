#!/bin/bash

echo "=== Please run with 'source proxy.sh', otherwise it has no effect on the current shell"

if [ -n "$1" ]; then
    proxySwitch="$1"
else
    echo "=== 开启或关闭网络代理？ [s/1] for start, [t/0] for terminate, [anything else] for no change."
    read -p ">>> " proxySwitch
fi

# function proxy() {
    if [ "$proxySwitch" == "s" ] || [ "$proxySwitch" == "1" ]; then
        export all_proxy=socks5://127.0.0.1:7898
        export http_proxy=socks5://127.0.0.1:7898
        export https_proxy=socks5://127.0.0.1:7898
        echo -e "--- 已开启网络代理"
    elif [ "$proxySwitch" == "t" ] || [ "$proxySwitch" == "0" ]; then
        unset all_proxy
        unset http_proxy
        unset https_proxy
        echo -e "--- 已关闭网络代理"
    else
        echo "--- Nothing changed."
    fi
# }

echo all_proxy="$all_proxy"
# ip.gs, ip.sb, ipinfo.io
curl ipinfo.io
echo " "
