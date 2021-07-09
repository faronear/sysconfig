@echo off

@ IF "%1" == "" (if exist D:\faronear (set BASEDIR=D:\faronear) else (set BASEDIR=..\..)) else (set BASEDIR=%1)

if not exist %BASEDIR% (
  echo *** [%BASEDIR%] not exist! Exit now. ***
  @ GOTO END
)

pushd %BASEDIR%
echo *** Current path = [%CD%] ***
for /d %%d in (*) do pushd %%d & (for /d %%d in (*) do if exist %%d/package.json (pushd %%d & echo --- npm booting: %%d ... & npm run boot & popd)) & popd
popd

pause

:END
