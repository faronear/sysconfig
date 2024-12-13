@echo off 

@REM 首先清除可能残留的变量
set ROOTPATH=

@ if not "" == "%1" (
  set ROOTPATH=%1
) else (
  echo;
  echo #<<< Enter [root path]> or [leave blank] for default to [[%CD%]]
  set /p ROOTPATH=">>> "
  echo;
  if "" == "%ROOTPATH%" (
    set ROOTPATH=%CD%
  )
)

if not exist %ROOTPATH% (
  echo ××× [[%ROOTPATH%]] not exist! Exit now. ***
  @ GOTO END
) else (
  echo √√√ ROOTPATH = [[%ROOTPATH%]]
)

pushd %ROOTPATH%
echo #<<< Current path = [[%CD%]]

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )

for /d %%o in (*) do (
  @REM windows的链接文件会造成路径错误，从而终止该循环，从而导致下一轮乃至所有循环的工作目录错误。因此要过滤掉 .vscode 这个符号链接目录。
  if not %%o == .vscode (
      echo   entering [[%ROOTPATH%\%%o]]
      pushd %%o
      for /d %%g in (*) do (
        if exist %%g\.git (
          pushd %%g
          @REM echo    changing repo url 
          @REM git remote remove origin
          @REM git remote add origin https://git.faronear.org/%%o/%%g
          @REM git pull
          @REM git branch --set-upstream-to=origin/main main
          @REM git pull
          echo    changing branch name
          git branch -m master main
          git push -u origin main
          git push origin :master
          popd
        )
      )
      popd
  )
)

popd

:END

pause

