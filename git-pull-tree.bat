@echo off 

@REM 首先清除可能残留的变量
set ROOTPATH=

set ROOTPATH1=D:\faronear
set ROOTPATH2=C:\faronear
set ROOTPATH3=%HOMEDRIVE%%HOMEPATH%\faronear

@ if not "" == "%1" (
  set ROOTPATH=%1
) else (
echo *** Testing Path [[%ROOTPATH1%]]  [[%ROOTPATH2%]]  [[%ROOTPATH3%]]
  if exist "%ROOTPATH1%" (
    set ROOTPATH=%ROOTPATH1%
  ) else if exist "%ROOTPATH2%" (
    set ROOTPATH=%ROOTPATH2%
  ) else if exist "%ROOTPATH3%" (
    set ROOTPATH=%ROOTPATH3%
  ) else (
      echo ××× none of the testing path is valid.
      echo;
      echo === Enter [root path]> or [leave blank] for default to [[%CD%]]
      set /p ROOTPATH=">>> "
      echo;
      if "" == "%ROOTPATH%" (
        set ROOTPATH=%CD%
      )
  )
)

if not exist "%ROOTPATH%" (
  echo ××× [[%ROOTPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ ROOTPATH = [[%ROOTPATH%]]
)

pushd %ROOTPATH%
echo *** Starting from [[%CD%]] ***
echo;

@ if "%2" == "hier" (
  @REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )
  for /d %%o in (*) do (
    @ if not "%%o" == ".vscode" (
      echo ======== entering [[%ROOTPATH%\%%o]] ========
      echo;
      pushd %%o
      for /d %%g in (*) do (
        if exist "%%g\.git" (
          pushd %%g
          echo ---- git pulling [[%ROOTPATH%\%%o\%%g]] ----
          git pull --all
          echo;
          popd
        )
      )
      popd
    )
  )
) else (
  for /d /r %%r in (*) do (
    @REM @ if not "%%r" == ".vscode" (
    echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
      if exist "%%r\.git" (
        pushd "%%r"
        echo ---- git pulling [[%%r]] ----
        git pull --all
        echo;
        popd
      )
    )
  )
)

popd

:END

pause

