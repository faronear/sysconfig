# install: https://docs.brew.sh/Installation
# 用 *.pkg 安装的效果和命令行其实一样
echo "Installing Homebrew on MacOS"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# default brew path: /opt/homebrew for Apple Silicon, /usr/local/Homebrew for macOS Intel and /home/linuxbrew/.linuxbrew for Linux

echo "if `brew --repo homebrew/core` not exists, you may need to git clone https://github.com/Homebrew/homebrew-core.git as well as for homebrew-cask"

# add brew to path on Apple Silicon:
# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/luk/.bash_profile
# eval "$(/opt/homebrew/bin/brew shellenv)"
# 实际上执行了：
# export HOMEBREW_PREFIX="/opt/homebrew";
# export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
# export HOMEBREW_REPOSITORY="/opt/homebrew";
# export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
# export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
# export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
# 

# uninstall: https://github.com/homebrew/install#uninstall-homebrew
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

