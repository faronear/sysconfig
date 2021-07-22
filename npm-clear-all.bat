@echo off 

echo *** Testing Path [%1]  [D:\faroenar]  [C:\faroenar]  [%HOMEDRIVE%%HOMEPATH%\faronear]  [../..] 

@ if not "%1" == "" (
  set BASEDIR=%1
) else (if exist D:\faronear (
  set BASEDIR=D:\faronear
) else (if exist C:\faronear (
  set BASEDIR=C:\faronear
) else (if exist %HOMEDRIVE%%HOMEPATH%\faronear (
  set BASEDIR=%HOMEDRIVE%%HOMEPATH%\faronear
) else (
  set BASEDIR=..\..
))))

if not exist %BASEDIR% (
  echo *** [%BASEDIR%] not exist! Exit now. ***
  @ GOTO END
)

pushd %BASEDIR%
echo *** Current path = [%CD%] ***

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )

for /d %%d in (*) do (
  pushd %%d
  for /d %%d in (*) do (
    if exist %%d/node_modules (
      pushd %%d
      echo Deleting %%d/node_modules ...
      rd /s /q node_modules
      popd
    )
  )
  popd
)

popd

pause
@GOTO END

:END
