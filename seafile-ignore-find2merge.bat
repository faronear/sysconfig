@echo off 

@REM 首先清除可能残留的变量
set ROOTPATH=

set ROOTPATH1=D:\faronear
set ROOTPATH2=C:\faronear
set ROOTPATH3=%HOMEDRIVE%%HOMEPATH%\faronear

@ if not "" == "%1" (
  set ROOTPATH=%1
) else (
echo *** Testing Path [[%ROOTPATH1%]]  [[%ROOTPATH2%]]  [[%ROOTPATH3%]]
  if exist "%ROOTPATH1%" (
    set ROOTPATH=%ROOTPATH1%
  ) else if exist "%ROOTPATH2%" (
    set ROOTPATH=%ROOTPATH2%
  ) else if exist "%ROOTPATH3%" (
    set ROOTPATH=%ROOTPATH3%
  ) else (
    echo ××× none of the testing path is valid.
    echo;
    echo === Enter [root path] or [leave blank] for default [[%CD%]] to start tree search for seafile-ignore.txt files
    set /p ROOTPATH=">>> "
    echo;
    if "" == "%ROOTPATH%" (
      set ROOTPATH=%CD%
    ) else (
      for %P in (%ROOTPATH%) do set "ROOTPATH=%~dpnxP"
    )
  )
)
if not exist "%ROOTPATH%" (
  echo ××× [[%ROOTPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ ROOTPATH = [[%ROOTPATH%]]
)

echo === Enter [path to seafile-ignore_global] or [leave blank] for default [[%CD%]]
set /p IGNOREPATH=">>> "
echo;
if "" == "%IGNOREPATH%" (
  set IGNOREPATH=%CD%/seafile-ignore_global
) else (
  for %P in (%IGNOREPATH%) do set "IGNOREPATH=%~dpnxP/seafile-ignore_global"
)
if not exist "%IGNOREPATH%" (
  echo ××× [[%IGNOREPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ IGNOREPATH = [[%IGNOREPATH%]]
)

pushd %ROOTPATH%
echo *** Starting from [[%CD%]] ***
echo;

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == ".vscode" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\seafile-ignore.txt" (
      echo ---- updating seafile-ignore.txt in [[%%r]] ----
      cat %IGNOREPATH% %%r\seafile-ignore_local > %%r\seafile-ignore.txt
      echo;
    )
  )
)


popd

:END

pause
