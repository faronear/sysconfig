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

echo === Enter [commit message] or leave blank for default to 'updated'
set /p COMMIT_MESSAGE=">>> "
@ if "" == "%COMMIT_MESSAGE%" (
  set COMMIT_MESSAGE="updated"
)
echo;

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )

for /d %%o in (*) do (
  @REM windows的链接文件会造成路径错误，从而终止该循环，从而导致下一轮乃至所有循环的工作目录错误。因此要过滤掉 .vscode 这个符号链接目录。
  if not "%%o" == ".vscode" (
    @REM 如果同时使用了 GIT 和 云盘进行管理，每次 git push 都会造成 .git 目录下某些文件变化，导致云盘不断自动同步。因此过滤掉云盘的目录不做更新。
    @REM echo "%%o" | findstr "=" >NUL && (
    @REM   echo !!!!!!!! omitting [%FONPATH%\%%o] !!!!!!!!
    @REM   echo;
    @REM ) || (
      echo ======== entering [%FONPATH%\%%o] ========
      echo;
      pushd %%o
      for /d %%g in (*) do (
        if exist %%g\.git (
          pushd %%g
          echo ---- git commit and push [%FONPATH%\%%o\%%g] ----
          git add . && git commit -m "%COMMIT_MESSAGE%" && git push
          echo;
          popd
        )
      )
      popd
    @REM )
  )
)

popd

:END

pause

