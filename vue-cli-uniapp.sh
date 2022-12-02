#!/bin/bash


echo *** 把 HBuilder 创建的 uniapp 应用转换成 vue-cli 应用的脚手架。
echo *** More info at https://uniapp.dcloud.net.cn/quickstart-cli.html

echo === CLI project name? 
read -p '>>> ' PROJECT

if [ $PROJECT ]
then
  npm i -g @vue/cli@4 ## 最新版 5.x 会导致 Hello-uni-app 报错无法找到一些库。该版本cli 要求 node 版本为 8 || 10 || 12 || 14 || 16 || 17
  vue create -p dcloudio/uni-preset-vue $PROJECT
  cd $PROJECT
  mv src src-old
  echo === Originial Repository URL?
  read -p '>>> ' $url
  echo 
  echo *** 下载一个 HBuilderX 创建的项目下载存为 src 目录:
  echo
  git clone $url src
  echo
  echo *** 进入 src 安装依赖库
  cd src
  npm run boot
  cd ..
  echo
  echo *** `npm run serve` to start
  echo
fi

## 如果 vue create 选择默认模板，生成的 package.json 其实和 Hello 版一摸一样，只是 devDependencies 缺少了 sass ^1.49.8 和 sass-loader ^8.0.2。
## 选择 Hello uni-app 作为模板，则有 sass 库，并且 src 下具有所有扩展UI组件，方便作为定制基础。
## 如果 `rm -fr node_modules && npm i`` 重新安装，再运行 `npm run serve`` 会出错 `Error: Cannot find module 'html-webpack-plugin'`。必须从 vue create 开始才可以运行。

## 严重注意，src 必须是直属目录，不能是符号链接！否则不论在 windows / nix 里都无法 npm run serve。