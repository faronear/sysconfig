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
    echo === none of the testing path is valid.
    echo === Enter [fonpath] or leave [blank] for default to '.'
    set /p FONPATH=">>> "
    echo;
    if "" == "%FONPATH%" (
      set FONPATH=.
    )
  )
)
if not exist "%FONPATH%" (
  echo *** [%FONPATH%] not exist! Exit now. ***
  @ GOTO END
) else (
  echo === FONPATH=%FONPATH%
)

set NIXHOME1=%FONPATH%\fon\sysconfig\nixhome
set NIXHOME2=%FONPATH%\fon.git\sysconfig\nixhome
set NIXHOME3=%FONPATH%\fon\sysconfig.git\nixhome
set NIXHOME4=%FONPATH%\fon.git\sysconfig.git\nixhome
set NIXHOME5=%CD%\nixhome
echo *** Testing Path [%NIXHOME1%] [%NIXHOME2%] [%NIXHOME3%] [%NIXHOME4%] [%NIXHOME5%]
if exist "%NIXHOME1%" (
  set NIXHOME=%NIXHOME1%
) else if exist "%NIXHOME2%" (
  set NIXHOME=%NIXHOME2%
) else if exist "%NIXHOME3%" (
  set NIXHOME=%NIXHOME3%
) else if exist "%NIXHOME4%" (
  set NIXHOME=%NIXHOME4%
) else if exist "%NIXHOME5%" (
  set NIXHOME=%NIXHOME5%
) else (
  echo === none of the testing path is valid.
  echo === Enter [nixhome path] or leave [blank] for default to '.'
  set /p NIXHOME=">>> "
  echo;
  if "" == "%NIXHOME%" (
    set NIXHOME=.
  )
)
if not exist "NIXHOME%" (
  echo *** [%NIXHOME%] not exist! Exit now. ***
  @ GOTO END
)else (
  echo === NIXHOME=%NIXHOME%
)

pushd %FONPATH%
echo *** Starting from [%CD%] ***
echo;

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == ".vscode" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\.git" (
      pushd "%%r"
      echo ---- updating .gitignore in [%%r] ----
      copy %NIXHOME%\.gitignore %%r\
      echo;
      popd
    )
  )
)


popd

:END

pause
