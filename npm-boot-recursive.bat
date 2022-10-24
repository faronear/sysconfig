@echo off 

@REM 首先清除可能残留的变量
set FONPATH=

@ if not "" == "%1" (
  set FONPATH=%1
) else (
  if exist D:\faronear (
    set FONPATH=D:\faronear
  ) else (if exist C:\faronear (
    set FONPATH=C:\faronear
  ) else (if exist %HOMEDRIVE%%HOMEPATH%\faronear (
    set FONPATH=%HOMEDRIVE%%HOMEPATH%\faronear
  ) else (
      echo === Enter [target path] or leave [blank] for default to `.`
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
  echo "%%r" | findstr "node_modules" >NUL || (
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

