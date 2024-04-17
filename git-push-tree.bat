@echo off 

@REM 首先清除可能残留的变量
set ROOTPATH=

@ if not "" == "%1" (
  set ROOTPATH=%1
) else (
  echo;
  echo === Enter [root path] or [leave blank] for default to [[%CD%]]
  set /p ROOTPATH=">>> "
  echo;
  if "" == "%ROOTPATH%" (
    set ROOTPATH=%CD%
  )
)

if not exist "%ROOTPATH%" (
  echo ××× [[%ROOTPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ ROOTPATH = [[%ROOTPATH%]]
)

pushd %ROOTPATH%
echo === Starting from [[%CD%]] ===
echo;

echo === Enter [commit message] or [leave blank] for default to 'updated'
set /p COMMIT_MESSAGE=">>> "
@ if "" == "%COMMIT_MESSAGE%" (
  set COMMIT_MESSAGE="updated"
)
echo;

@ if "%2" == "hier" (
  @REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )
  for /d %%o in (*) do (
    @ if not "%%o" == ".vscode" (
      echo ======== entering [[%ROOTPATH%\%%o]] ========
      echo;
      pushd "%%o"
      for /d %%g in (*) do (
        if exist %%g\.git (
          pushd "%%g"
          echo ---- git commit and push [[%ROOTPATH%\%%o\%%g]] ----
          git add . && git commit -m "%COMMIT_MESSAGE%" && git push
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
        echo ---- git commit and push [[%%r]] ----
        git add . && git commit -m "%COMMIT_MESSAGE%" && git push
        echo;
        popd
      )
    )
  )
)

popd

:END

pause

