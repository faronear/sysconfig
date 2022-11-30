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

echo === Enter [commit message] or [leave blank] for default to 'updated'
set /p COMMIT_MESSAGE=">>> "
@ if "" == "%COMMIT_MESSAGE%" (
  set COMMIT_MESSAGE="updated"
)
echo;

for /d /r %%r in (*) do (
  echo "%%r" | findstr "node_modules" >NUL && ( echo; ) || (
    if exist "%%r\.git" (
      pushd "%%r"
      echo ---- git commit and push [%%r] ----
      git add . && git commit -m "%COMMIT_MESSAGE%" && git push
      echo;
      popd
    )
  )
)


popd

:END

pause

