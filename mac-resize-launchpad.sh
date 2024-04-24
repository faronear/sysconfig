echo === Enter [row number] (7 for MBA, 9 for iMac) or [leave blank] for default to 9
read -p ">>> " ROWS
if [ "$ROWS" = "" ]
then
  ROWS = 9
fi
defaults write com.apple.dock springboard-rows -int $ROWS

echo === Enter [column number] (10 for MBA, 15 for iMac) or [leave blank] for default to 15
read -p ">>> " COLS
if [ "$COLS" = "" ]
then
  COLS = 15
fi
defaults write com.apple.dock springboard-columns -int $COLS

defaults write com.apple.dock ResetLaunchPad -bool true

killall Dock
