#!/bin/bash

get_char()
{
  SAVEDSTTY=`stty -g`
  stty -echo
  stty cbreak
  dd if=/dev/tty bs=1 count=1 2> /dev/null
  stty -raw
  stty echo
  stty $SAVEDSTTY
}

echo "Press any key to exit!"
char=`get_char`

# read -p "press Enter to exit!"
# echo "Bye!"