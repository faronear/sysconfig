#!/bin/bash

echo "=== Set [datadir] name, leave [blank] for default 'pex-data-poa'（可以尚未存在）:"
read -p ">>> " DATADIR
if [ ! "$DATADIR" ]
then
  DATADIR=chain-poa
fi
echo "*** DATADIR === $DATADIR "
echo ""

echo "=== Init accounts: [y] for yes, [anything else] for no change"
read -p ">>> " INIT_ACCOUNTS
if [ $INIT_ACCOUNTS ] && [ $INIT_ACCOUNTS == 'y' ]
then
  echo "--- 生成新账户，自动存放在 ./$DATADIR/keystore/"
  geth --datadir ./$DATADIR/ account list # 检查现有账户。如果 ./pex-data/ 已经有数据，就不用生成新账户
  # 生成 [datadir]/keystore/ 下的钱包文件。密码都设为 123
  geth --datadir ./$DATADIR/ account new # 0x3831e121b349aebaea8ed0c44d4c7cb7b15ad8ad 导入 MetaMask 可得私钥 0xd2ed4496be1251a7f55772bba6ef1106ec330e27002898a5e1c69cd4e39de965 用在 hardhat.config.js 的 network 定义里
  geth --datadir ./$DATADIR/ account new # 0x921b248a470f7d0bba40077c7aee3ab3440caa77 导入 MetaMask 可得私钥 0x155d0d6fb836244be84e12fb7d79c1ae8d4b398f045f9e1a4cfdfef6f21b8a8e
  echo "--- 请编写创世区块 genesis-$DATADIR.json ，设置新账户的初始金额 （PoW 的私有链挖矿比较容易，所以实际上不需要预置有币的账号，需要的时候自己挖矿获币也可以）"
else
  echo "--- Nothing changed."
fi
echo ""

echo "=== Init chain from genesis-$DATADIR.json: [y] for yes, [anything else] for no change"
read -p ">>> " INIT_CHAIN
if [ $INIT_CHAIN ] && [ $INIT_CHAIN == 'y' ]
then
  echo "--- 初始化链上数据，存放在 ./$DATADIR/geth/"
  geth --datadir ./$DATADIR/ init ./genesis-$DATADIR.json
else
  echo "--- Nothing changed."
fi
echo ""
