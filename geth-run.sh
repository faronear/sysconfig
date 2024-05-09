#!/bin/bash

DATADIR=$1

while [ ! "$DATADIR" ] || [ ! -d "./$DATADIR" ]
do
  echo "=== Set [datadir] name, leave [blank] for default 'pex-data-poa'"
  read -p ">>> " DATADIR
  if [ ! "$DATADIR" ]
  then
    DATADIR=chain-poa
  fi
done
echo ""


echo "Run geth in pm2? [y] for yes, [anything else] for raw geth:"
read -p ">>> " RUNPM2
echo "--- Creating ./$DATADIR/geth.ipc ..."
# http.addr 默认为 127.0.0.1 => 无法从远处连接。要用 0.0.0.0 才能从远处用 IP 连接。
# shh 是 whisper 协议，好像要先启动 websocket 接口才能启用。

while [ ! "$KEYCODE" ]
do
  echo "=== Define chain keycode, for instance '882' for tuc chain:"
  read -p ">>> " KEYCODE
done

if [ "$RUNPM2" == 'y' ]
then
  pm2 start -x 'geth' --name=$DATADIR -- --datadir=./$DATADIR/ --http --http.addr=0.0.0.0 --http.port=6$KEYCODE --http.api=eth,net,web3,personal,admin,miner,debug,txpool,shh --http.vhosts=* --http.corsdomain=* --nodiscover --networkid=6$KEYCODE --port=60$KEYCODE --allow-insecure-unlock --unlock 0xbC0ab80eef0A86eF248993D3f59B73F142278fbc --password ./keystore-password.txt --mine --miner.etherbase 0xbC0ab80eef0A86eF248993D3f59B73F142278fbc --miner.threads=1
else
  # 如果不是用 pm2 而是直接用 geth，那么可以在最后加 console。不提供password也可以，那就会在命令行提示输入。
  geth --datadir=./$DATADIR/ --http --http.addr=0.0.0.0 --http.port=6$KEYCODE --http.api=eth,net,web3,personal,admin,miner,debug,txpool --http.vhosts=* --http.corsdomain=* --nodiscover --networkid=6$KEYCODE --port=60$KEYCODE --allow-insecure-unlock --unlock 0xbC0ab80eef0A86eF248993D3f59B73F142278fbc --password=./keystore-password.txt --mine --miner.etherbase 0xbC0ab80eef0A86eF248993D3f59B73F142278fbc --miner.threads=1 console
fi
