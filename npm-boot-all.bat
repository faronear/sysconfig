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
for /d %%d in (*) do pushd %%d & (for /d %%d in (*) do if exist %%d/package.json (pushd %%d & echo --- npm booting: %%d ... & npm run boot & popd)) & popd
popd

pause

:END
