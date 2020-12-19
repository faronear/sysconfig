defaults write com.apple.dock springboard-rows -int 9

defaults write com.apple.dock springboard-columns -int 12

defaults write com.apple.dock ResetLaunchPad -bool true

defaults write com.apple.Dock autohide-delay -float 0

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

killall Dock
