local=killer-sDeb10-vMac.local
us1=us-nj-1.faronear.net
us2=us-nj-2.faronear.net
de1=de-1.faronear.net
de2=de-2.faronear.net
de3=de-3-arm.faronear.net
de4=de-4-arm.faronear.net
sh=cn-sh.faronear.net
wx=cn-wx.farinear.cn

if [ $1 ]
then
  TARGET=$1
else
  echo Connect to
  echo "  local : $local"
  echo "  us1 : $us1"
  echo "  us2 : $us2"
  echo "  de1 : $de1"
  echo "  de2 : $de2"
  echo "  de3 : $de3"
  echo "  de4 : $de4"
  echo "  sh  : $sh"
  echo "  wx  : $wx"
  echo
  echo "::*** Enter target (leave blank to specify host/user/pwd):"
  read -p "***:: " TARGET
  if [ ! $TARGET ]
  then
    TARGET=other
  fi
fi

eval targetUrl=\$${TARGET}

if [ $targetUrl ]
then
  read -p "Enter adot password (ROAD) >>" PWD_ADOT
  read -p "Enter root password (YU) >>" PWD_ROOT
  expect ~/faronear/npm/sysconfig/expect-ssh.sh $targetUrl adot $PWD_ADOT $PWD_ADOT
else
  while [ ! "$HOST" ]
  do
  read -p "host = " HOST
  done

  while [ ! "$USER" ]
  do
    read -p "user = " USER
  done
  
  while [ ! "$PWD_USER" ]
  do
    read -p "user password = " PWD_USER
  done

  while [ ! "$PWD_SU" ]
  do
    read -p "root password = " ROOT_SU
  done

  expect ~/sysconfig/expect-ssh.sh $HOST $USER $PWD_USER $PWD_SU
fi
