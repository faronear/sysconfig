#!/bin/bash

echo "=== Please run with 'source proxy.sh', otherwise it has no effect on the current shell"

if [ -n "$1" ]; then
  proxySwitch="$1"
else
  echo "=== 开启或关闭网络代理？ [s/1] for start, [t/0] for terminate, [anything else] for no change."
  read -p ">>> " proxySwitch
fi

# to reset port to empty, otherwise the second run of this script will not ask for port.
PORT=

# function proxy() {
  if [ "$proxySwitch" == "s" ] || [ "$proxySwitch" == "1" ]; then
    echo "=== Proxy server running on [port number] or [leave blank] for default 7897"
    while [ ! "$PORT" ]
    do
      read -p ">>> " PORT
      if [ ! "$PORT" ]
      then
        PORT=7897
      fi
    done
    export all_proxy=socks5://127.0.0.1:$PORT
    export http_proxy=socks5://127.0.0.1:$PORT
    export https_proxy=socks5://127.0.0.1:$PORT
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

echo all_proxy=$all_proxy
echo http_proxy=$http_proxy
echo https_proxy=$https_proxy

# ip.gs, ip.sb, ipinfo.io
curl ipinfo.io
echo " "
