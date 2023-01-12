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
  if exist "%FONPATH1" (
    set FONPATH=%FONPATH1%
  ) else (if exist "%FONPATH2%" (
    set FONPATH=%FONPATH2%
  ) else (if exist %FONPATH3% (
    set FONPATH=%FONPATH3%
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

NIXHOME1=%FONPATH%\fon\sysconfig\nixhome
NIXHOME2=%FONPATH%\fon.git\sysconfig\nixhome
NIXHOME3=%FONPATH%\fon\sysconfig.git\nixhome
NIXHOME4=%FONPATH%\fon.git\sysconfig.git\nixhome
NIXHOME5=`pwd`/nixhome

if exist "%NIXHOME1" (
  set NIXHOME=%NIXHOME1%
) else (if exist "%NIXHOME2" (
  set NIXHOME=%NIXHOME2%
) else (if exist "%NIXHOME3" (
  set NIXHOME=%NIXHOME3%
) else (if exist "%NIXHOME4" (
  set NIXHOME=%NIXHOME4%
) else (if exist "%NIXHOME5" (
  set NIXHOME=%NIXHOME5%
) else (
  echo === Enter [nixhome path] or leave [blank] for default to '.'
  set /p NIXHOME=">>> "
  echo;
  if "" == "%FONPATH%" (
    set NIXHOME=.
  )
)))))

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
