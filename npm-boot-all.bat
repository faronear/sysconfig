@echo off

@REM 首先清除可能残留的变量
set FONPATH=

set CHOICE1=D:\faronear
set CHOICE2=C:\faronear
set CHOICE3=%HOMEDRIVE%%HOMEPATH%\faronear

@ if not "" == "%1" (
  set FONPATH=%1
) else (
  echo *** Testing Path [%CHOICE1%]  [%CHOICE2]  [%CHOICE3]
  if exist "%CHOICE1" (
    set FONPATH=%CHOICE1%
  ) else (if exist "%CHOICE2%" (
    set FONPATH=%CHOICE2%
  ) else (if exist %CHOICE3% (
    set FONPATH=%CHOICE3%
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

pushd %FONPATH%
echo *** Starting from [%CD%] ***
echo;

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do if exist %%d/package.json ( pushd %%d & echo --- npm booting: %%d ... & npm run boot & popd ) ) & popd )

for /d %%o in (*) do (
  @ if not "%%o" == ".vscode" (
    echo ======== entering [%FONPATH%\%%o] ========
    echo;
    pushd %%o 
    for /d %%g in (*) do (
      @ if exist "%%g\package.json" (
        findstr "\"boot\"" %%g\package.json >NUL && (
          pushd %%g 
          echo ---- npm booting [%FONPATH%\%%o\%%g] ----
          npm run boot
          echo;
          popd
        )
      ) 
    ) 
    popd
  )
)

popd

:END

pause
