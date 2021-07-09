@echo off 

@ IF "%1" == "" (if exist D:\faronear (set BASEDIR=D:\faronear) else (set BASEDIR=..\..)) else (set BASEDIR=%1)

if not exist %BASEDIR% (
  echo *** [%BASEDIR%] not exist! Exit now. ***
  @ GOTO END
)

pushd %BASEDIR%
echo *** Current path = [%CD%] ***
for /d %%d in (*) do (
  pushd %%d
  for /d %%d in (*) do (
    if exist %%d/.git (
      pushd %%d
      echo ---  git pulling: %%d ...
      git pull
      popd
    )
  )
  popd
)
popd

pause
@GOTO END

:END
