#!/bin/bash

echo "Usage: setup.sh [VERSION]"
echo "Example: setup.sh 4.2"

if [ v$1 != v ]
then
  export Version=$1
else
  export Version=4.2
fi

curl https://www.mongodb.org/static/pgp/server-$Version.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/$Version main" | sudo tee /etc/apt/sources.list.d/mongodb-org-$Version.list
sudo apt update
sudo apt install mongodb-org -y
