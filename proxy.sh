#!/bin/bash

function proxy(){
    echo "=== 开启或关闭网络代理？ s for start, t for terminate, anything else for no change."
    read -p ">>> " proxySwitch
    if [ $proxySwitch ] && [ $proxySwitch == "s" ]
    then
        export ALL_PROXY=socks5://127.0.0.1:1086
        export http_proxy=http://127.0.0.1:8090
        export https_proxy=https://127.0.0.1:8090
        echo -e "--- 已开启网络代理"
    elif [ $proxySwitch ] && [ $proxySwitch == "t" ]
    then
        unset ALL_PROXY
        unset http_proxy
        unset https_proxy
        echo -e "--- 已关闭网络代理"
    else
        echo "--- Nothing changed."
    fi

    echo 测试 ip.gs, ip.sb, ipinfo.io
    curl ipinfo.io

}
proxy
