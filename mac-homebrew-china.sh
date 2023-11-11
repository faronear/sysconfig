echo === Enter [g] to reset git source to github, [c] to mirrors in china
read -p '>>> ' TARGET

if [ "$TARGET"='g' ]
then
  git -C /usr/local/Homebrew remote set-url origin https://github.com/Homebrew/brew.git
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core remote set-url origin https://github.com/Homebrew/homebrew-core.git
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask remote set-url origin https://github.com/Homebrew/homebrew-cask
elif [ "$TARGET"='c' ]
then
  git -C /usr/local/Homebrew remote set-url origin https://mirrors.ustc.edu.cn/brew.git 
  # 或 https://mirrors.aliyun.com/homebrew/brew.git
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git 
  # 或 https://mirrors.aliyun.com/homebrew/homebrew-core.git
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
fi

# https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
