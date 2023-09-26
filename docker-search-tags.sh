#!/bin/sh

echo "Usage:"
echo '  "this-script.sh [imageName]" to search library/[imageName]'
echo '  "this-script.sh [imageName] [ownerName]" to search [ownerName]/[imageName]'
echo '  "this.script.sh" to interactive enter [ownerName] and [imageName] to search'
echo

IMAGE=$1
while [ ! "$IMAGE" ] 
do
  echo "=== Enter [image name]:"
  read -p ">>> " IMAGE
  echo
done

OWNER=$2
if [ ! "$OWNER" ] 
then
  if [ "$1" ]
  then
    OWNER="library"
  else
    echo "=== Enter [owner name] or [empty] for default 'library':"
    read -p ">>> " OWNER
    if [ ! "$OWNER" ]
    then
      OWNER="library"
    fi
  fi
fi

echo
echo "=== Searching $OWNER/$IMAGE ......"
echo

page_size=100
page_index=0
while true; do 
  page_index=$((page_index+1))
  results=`curl -L -s "https://registry.hub.docker.com/v2/repositories/$OWNER/$IMAGE/tags?page=$page_index&page_size=$page_size" | jq -r 'select(.results != null) | .results[]["name"]'`
  if [ "$?" != 0 ] or [ "$results" == "" ]
  then
    break
  fi
  echo "$results"
done

echo
