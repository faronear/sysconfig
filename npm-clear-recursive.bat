@echo off 

@REM 首先清除可能残留的变量
set FONPATH=

@ if not "" == "%1" (
  set FONPATH=%1
) else (
  if exist D:\faronear (
    set FONPATH=D:\faronear
  ) else (if exist C:\faronear (
    set FONPATH=C:\faronear
  ) else (if exist %HOMEDRIVE%%HOMEPATH%\faronear (
    set FONPATH=%HOMEDRIVE%%HOMEPATH%\faronear
  ) else (
      echo === Enter [target path] or leave [blank] for default to `.`
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

for /d /r %%r in (*) do (
  @REM windows的链接文件会造成路径错误，从而终止该循环，从而导致下一轮乃至所有循环的工作目录错误。因此要过滤掉 .vscode 这个符号链接目录。
  if not "%%r" == ".vscode" (
    if exist "%%r\.git" (
      pushd "%%r"
      echo ---- Deleting [%FONPATH%\%%r] ----
      rd /s /q node_modules
      echo;
      popd
    )
  )
)

popd

pause
@GOTO END

:END
