echo 删除 LaunchPad 里残留的图标

# open /private/var/folders/ in Finder, search for 'launchpad', right-click & select 'Services -> New Terminal at Folder' to open it in terminal:

cd /private/var/folders/ht/rgh2n38j5mvc08wkxhlb1wlw0000gn/0/com.apple.dock.launchpad/db

sqlite3 db "delete from apps where title='要删除的图标的名称';" && killall Dock
