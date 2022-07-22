@echo off

@REM 首先清楚可能残留的变量
set FONPATH=

@ if not "" == "%1" (
  set FONPATH=%1
) else (
  echo === Enter [faronear root path] or leave blank for default to one of [D:\faronear], [C:\faronear], [%HOMEDRIVE%%HOMEPATH%\faronear], [.]
  set /p FONPATH=">>> "
  echo;
)

@ if "" == "%FONPATH%" (
  if exist D:\faronear (
    set FONPATH=D:\faronear
  ) else (if exist C:\faronear (
    set FONPATH=C:\faronear
  ) else (if exist "%HOMEDRIVE%%HOMEPATH%\faronear" (
    set FONPATH=%HOMEDRIVE%%HOMEPATH%\faronear
  ) else (
    set FONPATH=.
  )))
) else (
  if not exist "%FONPATH%" (
    echo *** [%FONPATH%] not exist! Exit now. ***
    @ GOTO END
  )
)

pushd %FONPATH%
echo *** FONPATH = [%CD%] ***
echo;

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do if exist %%d/package.json ( pushd %%d & echo --- npm booting: %%d ... & npm run boot & popd ) ) & popd )

for /d %%o in (*) do (
  @ if not "%%o" == ".vscode" (
    @ echo %%o | findstr "=" >NUL && (
      echo !!!!!!!! omitting [%FONPATH%\%%o] !!!!!!!!
      echo;
    ) || (
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
)

popd

:END

pause
