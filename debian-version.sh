#!/bin/bash

echo "#>>> cat /etc/issue"
cat /etc/issue
echo

echo "#>>> cat /etc/debian_version"
cat /etc/debian_version
echo

echo "#>>> cat /etc/os-release"
cat /etc/os-release
echo

echo "#>>> cat /etc/cpuinfo"
cat /etc/cpuinfo
echo

# echo "#>>> lsb-release"
# apt install lsb-release
# lsb-release -a
# echo

echo "#>>> hostnamectl"
hostnamectl
echo

echo "#>>> uname -a"
uname -a
echo