if [ $1 ]
then
  NewHostname=$1
else
  echo "=== Set <<hostname>> or leave blank for no change"
  read -p ">>> " NewHostname
fi

if [ $NewHostname ]
then
  OldHostname=`hostname`
  hostnamectl set-hostname $NewHostname
  sed -i "s|\b$OldHostname$\b|$NewHostname|g" /etc/hosts
  # echo "127.0.0.1 $NewHostname" >> /etc/hosts
else
  echo 'Nothing changed >>>'
fi
echo