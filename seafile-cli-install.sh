sudo wget https://linux-clients.seafile.com/seafile.asc -O /usr/share/keyrings/seafile-keyring.asc
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/seafile-keyring.asc] https://linux-clients.seafile.com/seafile-deb/$(lsb_release -cs)/ stable main" | sudo tee /etc/apt/sources.list.d/seafile.list > /dev/null
sudo apt update
sudo apt install -y seafile-cli

echo "To initialze the client, create a settings folder <path> or <leave blank> for default '~/seafile-client'"
read -p ">>> " SETTINGS_FOLDER
if [ ! $SETTINGS_FOLDER ]
then
  SETTINGS_FOLDER = ~/seafile-client
mkdir $SETTINGS_FOLDER
seaf-cli init -d $SETTINGS_FOLDER
seaf-cli start

echo To sync a librarcy, run commands like:
echo Download a new folder to sync with:
echo   seaf-cli download -l "library_id" -s "server_url" [-d "parent_folder"] -u "user_name"
echo   seaf-cli download-by-name -L "library_id" -s "server_url" [-d "target_folder_not_parent"] -u "user_name"
echo Sync with an existing folder:
echo   seaf-cli sync -l "library_id" -s "server_url" [-d "parent_folder"] -u "user_name"
echo   seaf-cli desync -d "existing lib folder"
echo Help:
echo   seaf-cli -h
echo   seaf-cli COMMAND -h

echo Check https://help.seafile.com/syncing_client/linux-cli/ for more details.