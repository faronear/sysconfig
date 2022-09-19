#!/bin/bash

function proxy(){
    echo "=== 开启或关闭网络代理？ u for up, d for down, anything else for no change."
    read -p ">>> " proxySwitch
    if [ $proxySwitch ] && [ $proxySwitch == "u" ]
    then
        export ALL_PROXY=socks5://127.0.0.1:8099
        export http_proxy=http://127.0.0.1:41091
        export https_proxy=https://127.0.0.1:41091
        echo -e "--- 已开启网络代理"
    elif [ $proxySwitch ] && [ $proxySwitch == "d" ]
    then
        unset ALL_PROXY
        unset http_proxy
        unset https_proxy
        echo -e "--- 已关闭网络代理"
    else
        echo "--- Nothing changed."
    fi
}
proxy
