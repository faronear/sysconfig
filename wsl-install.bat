echo Enable [Windows Subsystem for Linux] feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

echo Enable [Virtual Machinese Platform] feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

echo Download https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

wsl --set-default-version 2
wsl --update
wsl --shutdown
wsl --list --online
wsl --install -d Debian
