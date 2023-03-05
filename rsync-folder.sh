if [ $1 ]
then
  LOCALPATH=$1
else
  read -p "Enter localpath >> " LOCALPATH
fi

if [ $2 ]
then
  REMOTEPATH=$2
else
  read -p "Enter remote path (user@remotehost:/root/to/path/) >> " REMOTEPATH
fi

rsync -rvz -e ssh -p 22000 --progress $LOCALPATH $REMOTEHOST
