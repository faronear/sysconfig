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
  if exist "%FONPATH1" (
    set FONPATH=%FONPATH1%
  ) else (if exist "%FONPATH2%" (
    set FONPATH=%FONPATH2%
  ) else (if exist %FONPATH3% (
    set FONPATH=%FONPATH3%
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

echo === Enter [commit message] or [leave blank] for default to 'updated'
set /p COMMIT_MESSAGE=">>> "
@ if "" == "%COMMIT_MESSAGE%" (
  set COMMIT_MESSAGE="updated"
)
echo;

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )

for /d %%o in (*) do (
  @ if not "%%o" == ".vscode" (
    echo ======== entering [%FONPATH%\%%o] ========
    echo;
    pushd "%%o"
    for /d %%g in (*) do (
      if exist %%g\.git (
        pushd "%%g"
        echo ---- git commit and push [%FONPATH%\%%o\%%g] ----
        git add . && git commit -m "%COMMIT_MESSAGE%" && git push
        echo;
        popd
      )
    )
    popd
  )
)

popd

:END

pause

