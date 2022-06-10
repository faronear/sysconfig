echo *** Append ~/.ssh/id_rsa.pub to remote server

@ if not "%1" == "" (
  set REMOTEHOST=%1
) else (
  echo Please specify user@remotehost!
  @ goto END
)

scp %HOMEDRIVE%%HOMEPATH%\.ssh\id_rsa.pub %REMOTEHOST%:~/tmp.pub

ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"

echo ~/.ssh/id_rsa.pub is appended to %REMOTEHOST%:~/.ssh/authorized_keys

:END