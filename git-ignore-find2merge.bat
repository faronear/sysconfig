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
    echo === Enter [root path] or [leave blank] for default [[%CD%]] to start tree search for .gitignore files
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

echo === Enter [path to global .gitignore] or [leave blank] for default [[%CD%]]
set /p IGNOREPATH=">>> "
echo;
if "" == "%IGNOREPATH%" (
  set IGNOREPATH=%CD%
)
if not exist "%IGNOREPATH%" (
  echo ××× [[%IGNOREPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ IGNOREPATH = [[%IGNOREPATH%]]
)

for /d /r %%r in (*) do (
  @REM @ if not "%%r" == ".vscode" (
  echo "%%r" | findstr "node_modules uni_modules .deploy_git .git .svn .vscode unpackage _webroot _logstore _datasotre _archive _filestore _ssl" >NUL || (
    if exist "%%r\.git" (
      pushd "%%r"
      echo ---- updating .gitignore in [[%%r]] ----
      cat %IGNOREPATH%\.gitignore %%r\.gitignore_local > %%r\.gitignore
      echo;
      popd
    )
  )
)


popd

:END

pause
