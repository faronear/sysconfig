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

set SCRIPTHOME1=%FONPATH%\fon\sysconfig\nixhome
set SCRIPTHOME2=%FONPATH%\fon.git\sysconfig\nixhome
set SCRIPTHOME3=%FONPATH%\fon\sysconfig.git\nixhome
set SCRIPTHOME4=%FONPATH%\fon.git\sysconfig.git\nixhome
set SCRIPTHOME5=%CD%\nixhome
echo *** Testing Path [%SCRIPTHOME1%] [%SCRIPTHOME2%] [%SCRIPTHOME3%] [%SCRIPTHOME4%] [%SCRIPTHOME5%]
if exist "%SCRIPTHOME1%" (
  set SCRIPTHOME=%SCRIPTHOME1%
) else if exist "%SCRIPTHOME2%" (
  set SCRIPTHOME=%SCRIPTHOME2%
) else if exist "%SCRIPTHOME3%" (
  set SCRIPTHOME=%SCRIPTHOME3%
) else if exist "%SCRIPTHOME4%" (
  set SCRIPTHOME=%SCRIPTHOME4%
) else if exist "%SCRIPTHOME5%" (
  set SCRIPTHOME=%SCRIPTHOME5%
) else (
  echo ××× none of the testing path is valid.
  echo;
  echo === Enter [nixhome path] or leave [blank] for default to '.'
  set /p SCRIPTHOME=">>> "
  echo;
  if "" == "%SCRIPTHOME%" (
    set SCRIPTHOME=.
  )
)
if not exist "%SCRIPTHOME%" (
  echo ××× [%SCRIPTHOME%] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ SCRIPTHOME = %SCRIPTHOME%
)

pushd %FONPATH%
echo *** Starting from [%CD%] ***
echo;

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == ".vscode" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\.git" (
      echo ---- updating seafile-ignore.txt in [%%r] ----
      copy %SCRIPTHOME%\seafile-ignore.txt %%r\
      echo;
    )
  )
)


popd

:END

pause
