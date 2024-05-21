echo === Enter [g] to reset git source to github, [a] to 阿里云, [z] to 中科大, [q] to 清华, [anything else] to quit:
read -p '>>> ' TARGET

if [ "$TARGET" = 'g' ]
then
  git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
  git -C "$(brew --repo homebrew-core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew-cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask
elif [ "$TARGET" = 'z' ]
then
  git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git 
  git -C "$(brew --repo homebrew-core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git 
  git -C "$(brew --repo homebrew-cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
elif [ "$TARGET" = 'q' ]
then
  git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git 
  git -C "$(brew --repo homebrew-core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git 
  git -C "$(brew --repo homebrew-cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
elif [ "$TARGET" = 'a' ]
then
  git -C "$(brew --repo)" remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git 
  git -C "$(brew --repo homebrew-core)" remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git 
  git -C "$(brew --repo homebrew-cask)" remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-cask.git
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
else
  exit 0
fi

brew update
