echo "=== Install formulaes and casks, enter [y] for Yes, [anything else] for No:"
echo

formulaeList=(jq openssl pandoc speedtest-cli yt-dlp)
for APP in "${formulaeList[@]}"
do
  echo "--- brew install $APP"
  read -p ">>> " YN
  if [ "$YN" = 'y' ]
  then
    brew install $APP
  fi
  echo
  echo "*************************************************"
  echo
done

caskList=(appcleaner avidemux baidunetdisk cloudflare-warp cursor douyin drawio emacs futubull iina iterm2 lx-music miniconda obs poe qq seafile-client shotcut spacelauncher sqlitestudio telegram-desktop telegram-lite termius thunder warp wechat)
for APP in "${caskList[@]}"
do
  echo "--- brew install $APP"
  read -p ">>> " YN
  if [ "$YN" = 'y' ]
  then
    brew install $APP
  fi
  echo
  echo "*************************************************"
  echo
done
