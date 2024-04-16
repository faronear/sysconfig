defaults write com.apple.dock springboard-rows -int 9

defaults write com.apple.dock springboard-columns -int 15

defaults write com.apple.dock ResetLaunchPad -bool true

defaults write com.apple.Dock autohide-delay -float 0

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

# Don't create .DS_Store files 
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
# To enable: defaults delete com.apple.desktopservices DSDontWriteNetworkStores

killall Dock
