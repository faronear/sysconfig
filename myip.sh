if [ "$(uname)" = "Darwin" ]; then
  echo Local IP: $(ifconfig en0 | grep "inet " | awk '{print $2}')
elif [ "$(uname)" = "FreeBSD" ]; then
  MYIPLAN='' # hostname -I not work in FreeBSD
else
  echo Local IP: $(echo `hostname -I` | awk '{print $1;}')
fi

echo Public IP: `curl -s ifconfig.me`
echo

curl ipinfo.io