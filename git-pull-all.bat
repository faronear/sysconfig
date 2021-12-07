@echo off 

echo *** Testing Path [%1]  [D:\faronear]  [C:\faronear]  [%HOMEDRIVE%%HOMEPATH%\faronear]  [../..]

@ if not "%1" == "" (
  set BASEDIR=%1
) else (if exist D:\faronear (
  set BASEDIR=D:\faronear
) else (if exist C:\faronear (
  set BASEDIR=C:\faronear
) else (if exist %HOMEDRIVE%%HOMEPATH%\faronear (
  set BASEDIR=%HOMEDRIVE%%HOMEPATH%\faronear
) else (
  set BASEDIR=..\..
))))

if not exist %BASEDIR% (
  echo *** [%BASEDIR%] not exist! Exit now. ***
  @ GOTO END
)

pushd %BASEDIR%
echo *** Current path = [%CD%] ***
echo;

@REM for /d %%d in (*) do ( pushd %%d & ( for /d %%d in (*) do ( if exist %%d/.git pushd %%d & echo ---  git pulling: %%d ... & git pull & popd ) ) & popd )

for /d %%o in (*) do (
  @REM windows的链接文件会造成路径错误，从而终止该循环，从而导致下一轮乃至所有循环的工作目录错误。因此要过滤掉 .vscode 这个符号链接目录。
  if not %%o == .vscode (
    @REM 每次 git pull 都会造成 .git 目录下某些文件变化，导致云端不断自动同步。因此过滤掉 *@cloud 的目录不做更新。
    echo %%o | findstr "~cloud" >NUL && (
      echo !!! omitting [%BASEDIR%\%%o]
      echo;
    ) || (
      echo entering [%BASEDIR%\%%o]
      echo;
      pushd %%o
      for /d %%g in (*) do (
        if exist %%g\.git (
          pushd %%g
          echo git pulling [%BASEDIR%\%%o\%%g]
          git pull
          echo;
          popd
        )
      )
      popd
    )
  )
)

popd

:END

pause

