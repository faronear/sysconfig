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
      echo === none of the testing path is valid.
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
