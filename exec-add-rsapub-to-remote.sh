if [ $1 ]
then
  REMOTEHOST=$1
else
  read -p "Enter user@remotehost " REMOTEHOST
fi

scp ~/.ssh/id_rsa.pub $REMOTEHOST:~/tmp.pub

ssh $REMOTEHOST "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"
