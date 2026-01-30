echo Local IP: $(echo `hostname -I` | awk '{print $1;}')

echo Public IP: `curl -s ifconfig.me`
echo
