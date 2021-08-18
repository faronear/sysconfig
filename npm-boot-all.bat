@echo off

echo *** Testing Path [%1]  [D:\faronear]  [C:\faronear]  [%HOMEDRIVE%%HOMEPATH%\faronear]  [../..]

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

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do if exist %%d/package.json ( pushd %%d & echo --- npm booting: %%d ... & npm run boot & popd ) ) & popd )

for /d %%o in (*) do (
  if not %%o == .vscode (
    echo %%o | findstr "@cloud" && (
      echo   omitting [%BASEDIR%\%%o]
    ) || (
      echo   entering [%BASEDIR%\%%o]
      pushd %%o 
      for /d %%g in (*) do (
        if exist %%g/package.json (
          pushd %%g 
          echo     npm booting [%BASEDIR%\%%o\%%g] 
          npm run boot
          popd 
        ) 
      ) 
      popd
    )
  )
)

popd

:END

pause
