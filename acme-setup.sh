while [ ! "$TARGET_HOSTNAME" ]
do
  echo "::*** DNS name such as www.example.com: "
  read -p "***:: " TARGET_HOSTNAME
done
echo "*** -d $TARGET_HOSTNAME"
echo

while [ ! "$ISSUEMODE" ]
do
  echo "::*** Issue mode:"
  echo "    [s] for standalone"
  echo "    [w] for webroot"
  echo "    [n] for nginx"
  echo "    [a] for apache"
  echo "    [c] for challenge-alias"
  echo "    [d] for dnsapi"
  read -p "***:: " ISSUEMODE
  if [ "$ISSUEMODE" == 's' ]
  then 
    ISSUEPARM="--standalone"
  elif [ "$ISSUEMODE" == 'w' ]
  then 
    ISSUEPARM="-w"
  elif [ "$ISSUEMODE" == 'n' ]
  then 
    ISSUEPARAM="--nginx"
  elif [ "$ISSUEMODE" == 'a' ]
  then 
    ISSUEPARM="--apache"
  elif [ "$ISSUEMODE" == 'c' ]
  then 
    ISSUEPARM="--challenge-alias"
  elif [ "$ISSUEMODE" == 'd' ]
  then
    ISSUEPARM="--dns"
  else
    ISSUEMODE=''
  fi
done
echo "*** $ISSUEPARM"
echo

if [ "$ISSUEMODE" == 'd' ]
then
  while [ ! "$DNSAPI" ]
  do
    echo "::*** DNS API provider, [cf] for CloudFlare, [dp] for DNSPod/腾讯云, [ali] for Aliyun/阿里云:"
    read -p "***:: " DNSAPI_PROVIDER
    if [ "$DNSAPI_PROVIDER" == 'cf' ]
    then
      DNSAPI='dns_cf'
    elif [ "$DNSAPI_PROVIDER" == 'dp' ]
    then
      DNSAPI='dns_dp'
    elif [ "$DNSAPI_PROVIDER" == 'ali ']
    then
      DNSAPI='dns_ali'
    else
      DNSAPI=''
    fi
  done
  echo "*** $DNSAPI"
  echo
fi

echo "*** Issue Certificate:"
echo "*** ~/.acme.sh/acme.sh --issue -d $TARGET_HOSTNAME $ISSUEPARM $DNSAPI"
echo "***"
~/.acme.sh/acme.sh --issue -d $TARGET_HOSTNAME $ISSUEPARM $DNSAPI
echo

echo "::*** Install certificates? [n] for no, [anything else] to install: "
read -p "***:: " INSTALL_CERT
if [ "$INSTALL_CERT" != 'n' ]
then
  echo
  while [ ! "$KEY_FILE_PATH" ]
  do
    echo "::*** Deploy key file to: "
    read -p "***:: " KEY_FILE_PATH
  done
  echo
  while [ ! "$FULLCHAIN_FILE_PATH" ]
  do
    echo "::*** Deploy fullchain file to: "
    read -p "***:: " FULLCHAIN_FILE_PATH
  done
  echo 
  echo "::*** Set reload command, [leave blank] for default to 'service nginx force-reload'"
  read -p "***:: " RELOADCMD
  if [ ! "$RELOADCMD" ]
  then
    RELOADCMD="service nginx force-reload"
  fi
  echo
  
  echo "*** Install Certificate:"
  echo "~/.acme.sh/acme.sh --install-cert -d $TARGET_HOSTNAME --key-file $KEY_FILE_PATH --fullchain-file $FULLCHAIN_FILE_PATH --reloadcmd \"$RELOADCMD\""
  echo "***"
  ~/.acme.sh/acme.sh --install-cert -d $TARGET_HOSTNAME --key-file $KEY_FILE_PATH --fullchain-file $FULLCHAIN_FILE_PATH --reloadcmd "$RELOADCMD"
  echo
fi
