#!/bin/bash

echo Usage: this_script.sh [selected_index] [to_run_cmd]

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and run the script again."
    exit 1
fi

# Path to the settings.json file
SETTINGS_FILE="$HOME/Library/Application Support/Code/User/settings.json"
if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo "settings.json file not found!"
    exit 1
fi

# 自定义的列表，但是测试有问题，只有第一行被select添加了序号
# targets=$(jq -r '.["sshfs.configs"][] | "\(.name)"' "$SETTINGS_FILE")
# if [ -z "$targets" ]
# then
#   echo "No configurations found in the settings.json file."
#   exit 1
# fi

# Parse the JSON to get labels and corresponding details
labels=($(jq -r '.["sshfs.configs"][] | .label' "$SETTINGS_FILE"))
hosts=($(jq -r '.["sshfs.configs"][] | .host' "$SETTINGS_FILE"))
ports=($(jq -r '.["sshfs.configs"][] | .port' "$SETTINGS_FILE"))
names=($(jq -r '.["sshfs.configs"][] | .name' "$SETTINGS_FILE"))
usernames=($(jq -r '.["sshfs.configs"][] | .username' "$SETTINGS_FILE"))
passwords=($(jq -r '.["sshfs.configs"][] | .password' "$SETTINGS_FILE"))
privateKeyPaths=($(jq -r '.["sshfs.configs"][] | .privateKeyPath' "$SETTINGS_FILE"))

if [ "$1" -ge 0 ] 2>/dev/null && [ "$1" -le ${#hosts[@]} ] 2>/dev/null
then
  selected_index=$1-1
else
  echo "Select a target to connect via SSH:"
  select target in "${labels[@]}"
  do
    if [[ -n "$target" ]]; then
      selected_index=$REPLY-1
      break
    else
      echo "Invalid selection. Try again."
    fi
  done
fi

label="${labels[$selected_index]}"
name="${names[$selected_index]}"
host="${hosts[$selected_index]}"
port="${ports[$selected_index]}"
username="${usernames[$selected_index]}"
password="${passwords[$selected_index]}"
privateKeyPath="${privateKeyPaths[$selected_index]}"

if [ "$port" = "null" ]
then
  port=22
fi

if [ "$password" != "" ] & [ "$(which sshpass)" != "" ]
then
  echo "#<<< Coonecting to ${label} with password"
  echo "#>>> ssh -X -p $port $username@$host"
  sshpass -p $password ssh -X -p $port "$username@$host" $2
else
  echo "#<<< Coonecting to ${label} with private key"
  echo "#>>> ssh -X -p $port $username@$host"
  ssh -X -p $port "$username@$host" $2
fi