if [ $1 ]
then
  NewHostname=$1
else
  echo "#<<< Set [new hostname] or [leave blank] for no change"
  read -p "#>>> " NewHostname
fi

if [ $NewHostname ]
then
  hostnamectl set-hostname $NewHostname
  sed -i "s|\b$`hostname`\b|$NewHostname|g" /etc/hosts # echo "127.0.0.1 $NewHostname" >> /etc/hosts
else
  echo 'Nothing changed #>>>'
fi
echo
