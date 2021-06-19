#!/bin/bash

read -p "Enable autologin as user? >>> " UserName
if [ $UserName ]
then
  sed -i "s/^.*autologin-user=.*$/autologin-user=$UserName/g" /etc/lightdm/lightdm.conf
  sed -i "s/^.*autologin-user-timeout=.*$/autologin-user-timeout=0/g" /etc/lightdm/lightdm.conf
else
  echo 'Nothing changed.'
fi

