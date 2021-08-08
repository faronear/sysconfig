REM 介绍 https://winscp.net/eng/docs/guide_windows_openssh_server#installing_sftp_ssh_server
REM 下载 https://github.com/PowerShell/Win32-OpenSSH/releases
REM open a CMD or PowerShell as Administrator, then run this bat.

cd C:\bin\OpenSSH-Win64

powershell.exe -ExecutionPolicy Bypass -File .\install-sshd.ps1

.\ssh-keygen.exe -A

powershell.exe -ExecutionPolicy Bypass -File .\FixHostFilePermissions.ps1

REM Windows 8 and 2012 or newer only:
powershell.exe New-NetFirewallRule -Protocol TCP -LocalPort 22 -Direction Inbound -Action Allow -DisplayName SSH

sc config sshd start=auto
sc start sshd
