#!/bin/bash

## "curl -s https://git.tic.cc/opx/sysconfig/raw/branch/main/debian-update.sh | bash"

echo "Update Debian's currently-installed major version to the next newer major version. For instance, update 11 to 12, or 12 to 13"
echo

if [ -f /etc/debian_version ]; then
  OsTypeNow="Debian"
  OsVersionNow=`cat /etc/debian_version 2>/dev/null`
  OsMajorVersionNow=`echo $OsVersionNow | cut -d '.' -f 1`
# elif [ -f /etc/ubuntu_version ]; then
#   OsTypeNow="Ubuntu"
#   OsVersionNow=`cat /etc/ubuntu_version 2>/dev/null`
else
  echo "Unsupported OS. Only Debian can be updated."
  echo
  exit 1
fi

echo Current OS: $OsTypeNow $OsVersionNow
echo

# set CodeNameNow and CodeNameNext based on the current version
if [ "$OsTypeNow" = "Debian" ]; then
  if [ "$OsMajorVersionNow" = "11" ]; then
    CodeNameNow="bullseye"
    CodeNameNext="bookworm"
  elif [ "$OsMajorVersionNow" = "12" ]; then
    CodeNameNow="bookworm"
    CodeNameNext="trixie"
  else
    echo "Unsupported Debian version: $OsVersionNow"
    echo
    exit 1
  fi
else
  echo "Unsupported OS type: $OsTypeNow"
  echo
  exit 1
fi

echo "::*** Are you sure to update $OsTypeNow $CodeNameNow to $CodeNameNext?"
echo "  [y] Yes, update now"
echo "  [anything else] No, cancel update"
echo
read -p "***:: " answer
if [ "$answer" != "y" ]; then
  echo "Update canceled."
  exit 0
fi

# 检查并解除包锁定（有锁定会导致升级失败）
apt-mark showhold | grep -v "^$" && apt-mark unhold $(apt-mark showhold)
# 更新11系统至最新版本
apt update && apt upgrade -y
apt full-upgrade -y  # 处理依赖与内核升级
apt --purge autoremove -y  # 清理无用包
apt clean  # 清空APT缓存

# 替换bullseye为bookworm（覆盖主配置与子目录）
sed -i "s/$CodeNameNow/$CodeNameNext/g" /etc/apt/sources.list
sed -i "s/$CodeNameNow/$CodeNameNext/g" /etc/apt/sources.list.d/*.list

apt update
# 先最小升级（仅更新包，不安装/删除新包）
apt upgrade --without-new-pkgs -y
# 完整升级（处理依赖、内核替换、包移除）
apt full-upgrade -y

apt --purge autoremove -y
apt clean

echo
echo "🎉 Successfully Updated! You can reboot now."