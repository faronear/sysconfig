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
  set FONPATH=..\..
))))

if not exist %FONPATH% (
  echo *** [%FONPATH%] not exist! Exit now. ***
  @ GOTO END
)

pushd %FONPATH%
echo *** Current path = [%CD%] ***

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )

for /d %%o in (*) do (
  @REM windows的链接文件会造成路径错误，从而终止该循环，从而导致下一轮乃至所有循环的工作目录错误。因此要过滤掉 .vscode 这个符号链接目录。
  if not %%o == .vscode (
      echo   entering [%FONPATH%\%%o]
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

