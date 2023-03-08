#!/bin/bash

function proxy(){
    echo "=== 开启或关闭网络代理？ s for start, t for terminate, anything else for no change."
    read -p ">>> " proxySwitch
    if [ $proxySwitch ] && [ $proxySwitch == "s" ]
    then
        export all_proxy=socks5://127.0.0.1:1086
        export http_proxy=socks5://127.0.0.1:1086
        export https_proxy=socks5://127.0.0.1:1086
        echo -e "--- 已开启网络代理"
    elif [ $proxySwitch ] && [ $proxySwitch == "t" ]
    then
        unset all_proxy
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
