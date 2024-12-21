echo "::*** Install formulaes and casks, enter [y] for Yes, [anything else] for No:"
echo

formulaeList=(cloudflared jq openssl pandoc rclone readline speedtest-cli hudochenkov/sshpass/sshpass v2ray v2raya/v2raya/v2raya yt-dlp)
for APP in "${formulaeList[@]}"
do
  echo "--- brew install $APP"
  read -p "***:: " YN
  if [ "$YN" = 'y' ]
  then
    brew install $APP
  fi
  echo
  echo "*************************************************"
  echo
done

caskList=(appcleaner avidemux baidunetdisk cloudflare-warp cursor discord douyin drawio emacs futubull mysql-client iina iterm2 lx-music miniconda obs poe qq seafile-client shotcut spacelauncher sqlitestudio telegram-desktop termius thunder warp wechat xquartz)
for APP in "${caskList[@]}"
do
  echo "--- brew install $APP --cask"
  read -p "***:: " YN
  if [ "$YN" = 'y' ]
  then
    brew install $APP
  fi
  echo
  echo "*************************************************"
  echo
done
