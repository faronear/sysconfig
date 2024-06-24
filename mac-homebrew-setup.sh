echo "=== Install formulaes and casks, enter [y] for Yes, [anything else] for No:"
echo

formulaeList=(jq openssl pandoc speedtest-cli sqlite yt-dlp)
for APP in "${formulaeList[@]}"
do
  echo "--- brew install $APP"
  read -p ">>> " YN
  if [ "$YN" = 'y' ]
  then
    echo brew install $APP
  fi
done

caskList=(appcleaner avidemux baidunetdisk cloudflare-warp cursor douyin drawio emacs futubull iina lx-music miniconda obs poe qq seafile-client shotcut spacelauncher sqlitestudio telegram-desktop telegram-lite termius thunder warp wechat)
for APP in "${formulaeList[@]}"
do
  echo "--- brew install $APP"
  read -p ">>> " YN
  if [ "$YN" = 'y' ]
  then
    echo brew install $APP
  fi
done