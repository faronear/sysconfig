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

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )

for /d %%o in (*) do (
  @REM windows的链接文件会造成路径错误，从而终止该循环，从而导致下一轮乃至所有循环的工作目录错误。因此要过滤掉 .vscode 这个符号链接目录。
  @ if not "%%o" == ".vscode" (
    echo ======== entering [%FONPATH%\%%o] ========
    echo;
    pushd %%o
    for /d %%g in (*) do (
      if exist %%g\node_modules (
        pushd %%g
        echo ---- Deleting [%%g\node_modules] ----
        rd /s /q node_modules
        echo;
        popd
      )
    )
    popd
  )
)

popd

pause
@GOTO END

:END
