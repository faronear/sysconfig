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
  if not "%%r" == "node_modules" (
    if exist "%%r\node_modules" (
      pushd "%%r"
      echo ---- Deleting [%FONPATH%\%%r] ----
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
