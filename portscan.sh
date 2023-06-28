if [ "$1" ]
then
  PORT=$1
else
  echo "=== 需要查看的端口号:"
  read -p ">>> " PORT
fi

if [ "$(uname)" = "Darwin" ]
then
  lsof -i tcp:$PORT
else
  netstat -tunlp | grep $PORT
fi
