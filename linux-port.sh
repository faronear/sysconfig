echo "=== 需要查看的端口号:"
read -p ">>> " PORT

netstat -tunlp | grep $PORT
