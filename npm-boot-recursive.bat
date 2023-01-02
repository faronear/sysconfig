@echo off 

@REM 首先清除可能残留的变量
set FONPATH=

set CHOICE1=D:\faronear
set CHOICE2=C:\faronear
set CHOICE3=%HOMEDRIVE%%HOMEPATH%\faronear

@ if not "" == "%1" (
  set FONPATH=%1
) else (
  echo *** Testing Path [%CHOICE1%]  [%CHOICE2]  [%CHOICE3]
  if exist "%CHOICE1" (
    set FONPATH=%CHOICE1%
  ) else (if exist "%CHOICE2%" (
    set FONPATH=%CHOICE2%
  ) else (if exist %CHOICE3% (
    set FONPATH=%CHOICE3%
  ) else (
      echo === Enter [target path] or leave [blank] for default to '.'
      set /p FONPATH=">>> "
      echo;
      if "" == "%FONPATH%" (
        set FONPATH=.
      )
  )))
)

if not exist "%FONPATH%" (
  echo *** [%FONPATH%] not exist! Exit now. ***
  @ GOTO END
)

pushd %FONPATH%
echo *** Starting from [%CD%] ***
echo;

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == "node_modules" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\package.json" (
      findstr "\"boot\"" "%%r\package.json" >NUL && (
        pushd %%r
        echo ---- npm booting [%FONPATH%\%%r] ----
        npm run boot
        echo;
        popd
      )
    )
  )
)

popd

:END

pause

