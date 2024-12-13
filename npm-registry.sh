echo 1. npm config set registry https://registry.npmmirror.com
echo 2. 命令行指定: npm --registry https://registry.npmmirror.com info underscore
echo 3. edit ~/.npmrc: registry=https://registry.npmmirror.com
echo 4. 使用 nrm 管理 registry 地址:
echo   npm install -g nrm
echo   nrm add taobao https://registry.npmmirror.com
echo   nrm use taobao
echo   nrm ls
echo   nrm current
echo

echo "#<<< npm config get registry ==> $(npm config get registry)"
echo
echo "#<<< npm config set registry \n [c] China, \n [w] World, [anything else] to quit"
read -p "#>>> " TARGET
if [ "$TARGET" = 'c' ]
then
  npm config set registry https://registry.npmmirror.com
elif [ "$TARGET" = 'w' ]
then
  npm config set registry https://registry.npmjs.org
fi
echo
echo "#<<< npm config get registry ==> $(npm config get registry)"