if [ "$1" ]
then
  PORT=$1
else
  echo "=== 需要查看的端口号:"
  read -p ">>> " PORT
fi

lsof -i tcp:$PORT