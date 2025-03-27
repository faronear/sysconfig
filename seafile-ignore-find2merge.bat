@echo off 

@REM 首先清除可能残留的变量
set ROOTPATH=

@ if not "" == "%1" (
  set ROOTPATH=%1
) else (
  echo;
  echo ::*** Enter [root path] or [leave blank] for default [[%CD%]] to start tree search for seafile-ignore.txt files
  set /p ROOTPATH=">>> "
  echo;
  if "" == "%ROOTPATH%" (
    set ROOTPATH=%CD%
  ) else (
    for %P in (%ROOTPATH%) do set "ROOTPATH=%~dpnxP"
  )
)
if not exist "%ROOTPATH%" (
  echo ××× [[%ROOTPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ ROOTPATH = [[%ROOTPATH%]]
)

echo ::*** Enter [path to seafile-ignore.global.txt] or [leave blank] for default [[https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/seafile-ignore.global.txt]]
set /p IGNOREPATH=">>> "
echo;
if "" == "%IGNOREPATH%" (
  set IGNOREPATH=https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/seafile-ignore.global.txt
) else (
  for %P in (%IGNOREPATH%) do set "IGNOREPATH=%~dpnxP/seafile-ignore.global.txt"
  if not exist "%IGNOREPATH%" (
    echo ××× [[%IGNOREPATH%]] not exist! Exit now. ***
    @ GOTO END
  ) else (
    echo √√√ IGNOREPATH = [[%IGNOREPATH%]]
  )
)

pushd %ROOTPATH%
echo ::*** Starting from [[%CD%]]
echo;

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == ".vscode" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\seafile-ignore.txt" (
      echo ---- updating seafile-ignore.txt in [[%%r]] ----
      cat %IGNOREPATH% %%r\seafile-ignore.local.txt > %%r\seafile-ignore.txt
      echo;
    )
  )
)


popd

:END

pause
