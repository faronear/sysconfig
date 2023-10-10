echo "=== Add a non-root user to run docker"
if [ "$1" ]
then
  DOCKERUSER=$1
else
  echo "Enter the [user name] or [leave blank] for default to '`whoami`'"
  read -p ">>> " DOCKERUSER
  if [ ! "$DOCKERUSER" ]
  then
    DOCKERUSER=`whoami`
  fi
fi

sudo usermod -aG docker $DOCKERUSER
sudo systemctl restart docker
groups $DOCKERUSER
newgrp docker  # run as the docker group in the current shell
