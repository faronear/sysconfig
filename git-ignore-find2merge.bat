@echo off 

@REM 首先清除可能残留的变量
set ROOTPATH=

@ if not "" == "%1" (
  set ROOTPATH=%1
) else (
    echo;
    echo ::*** Enter [root path] or [leave blank] for default [[%CD%]] to start tree search for .gitignore files
    set /p ROOTPATH=">>> "
    echo;
    if "" == "%ROOTPATH%" (
      set ROOTPATH=%CD%
    ) else (
      for %P in (%ROOTPATH%) do set "ROOTPATH=%~dpnxP"
    )
)
if not exist "%ROOTPATH%" (
  echo ××× [[%ROOTPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ ROOTPATH = [[%ROOTPATH%]]
)

echo ::*** Enter [path to .gitignore.global.txt] or [leave blank] for default [[https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/.gitignore.global.txt]]
set /p IGNOREPATH=">>> "
echo;
if "" == "%IGNOREPATH%" (
  set IGNOREPATH=https://git.tic.cc/npm/sysconfig/raw/branch/main/nixhome/.gitignore.global.txt
) else (
  for %P in (%IGNOREPATH%) do set "IGNOREPATH=%~dpnxP/.gitignore.global.txt"
  if not exist "%IGNOREPATH%" (
    echo ××× [[%IGNOREPATH%]] not exist! Exit now. ***
    @ GOTO END
  ) else (
    echo √√√ IGNOREPATH = [[%IGNOREPATH%]]
  )
)

pushd %ROOTPATH%
echo ::*** Starting from [[%CD%]]
echo;

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == ".vscode" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\.git" (
      pushd "%%r"
      echo ---- updating .gitignore in [[%%r]] ----
      cat %IGNOREPATH%\.gitignore %%r\.gitignore.local.txt > %%r\.gitignore
      echo;
      popd
    )
  )
)


popd

:END

pause
