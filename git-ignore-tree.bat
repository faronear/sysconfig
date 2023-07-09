@echo off 

@REM 首先清除可能残留的变量
set FONPATH=

set FONPATH1=D:\faronear
set FONPATH2=C:\faronear
set FONPATH3=%HOMEDRIVE%%HOMEPATH%\faronear

@ if not "" == "%1" (
  set FONPATH=%1
) else (
  echo *** Testing Path [%FONPATH1%]  [%FONPATH2%]  [%FONPATH3%]
  if exist "%FONPATH1%" (
    set FONPATH=%FONPATH1%
  ) else if exist "%FONPATH2%" (
    set FONPATH=%FONPATH2%
  ) else if exist "%FONPATH3%" (
    set FONPATH=%FONPATH3%
  ) else (
    echo ××× none of the testing path is valid.
    echo;
    echo === Enter [fonpath] or leave [blank] for default to '.'
    set /p FONPATH=">>> "
    echo;
    if "" == "%FONPATH%" (
      set FONPATH=.
    )
  )
)
if not exist "%FONPATH%" (
  echo ××× [%FONPATH%] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ FONPATH = %FONPATH%
)

echo === Enter [path to .gitignore] or leave [blank] for default to '.'
set /p GITIGNOREPATH=">>> "
echo;
if "" == "%GITIGNOREPATH%" (
  set GITIGNOREPATH=.
)
if not exist "%GITIGNOREPATH%" (
  echo ××× [%GITIGNOREPATH%] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ GITIGNOREPATH = %GITIGNOREPATH%
)

pushd %FONPATH%
echo *** Starting from [%CD%] ***
echo;

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == ".vscode" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\.gitignore" (
      pushd "%%r"
      echo ---- updating .gitignore in [%%r] ----
      copy %GITIGNOREPATH%\.gitignore %%r\
      echo;
      popd
    )
  )
)


popd

:END

pause
