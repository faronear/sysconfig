@echo off 

@REM 首先清除可能残留的变量
set ROOTPATH=

@ if not "" == "%1" (
  set ROOTPATH=%1
) else (
  if exist D:\faronear (
    set ROOTPATH=D:\faronear
  ) else (if exist C:\faronear (
    set ROOTPATH=C:\faronear
  ) else (if exist %HOMEDRIVE%%HOMEPATH%\faronear (
    set ROOTPATH=%HOMEDRIVE%%HOMEPATH%\faronear
  ) else (
      echo ××× none of the testing path is valid.
      echo;
      echo === Enter [root path] or [leave blank] for default to [[%CD%]]
      set /p ROOTPATH=">>> "
      echo;
      if "" == "%ROOTPATH%" (
        set ROOTPATH=%CD%
      )
  )))
)

if not exist "%ROOTPATH%" (
  echo ××× [[%ROOTPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ ROOTPATH = [[%ROOTPATH%]]
)

pushd %ROOTPATH%
echo *** Starting from [[%CD%]] ***
echo;

for /d /r %%r in (*) do (
  @REM if not "%%r" == "node_modules" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\node_modules" (
      pushd "%%r"
      echo ---- Deleting [[%ROOTPATH%\%%r]] ----
      rd /s /q node_modules
      echo;
      popd
    )
  )
)

popd

pause
@GOTO END

:END
