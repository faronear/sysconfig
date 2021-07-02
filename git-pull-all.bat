@echo off 

@ IF "%1" == "" (set BASEDIR=..\..) else (set BASEDIR=%1)
echo [ Goto %BASEDIR% as base directory ]

pushd %BASEDIR%
echo [ %CD% ]
for /d %%d in (*) do pushd %%d & (for /d %%d in (*) do if exist %%d/.git (pushd %%d & echo ---  git pulling: %%d ...  & git pull & popd)) & popd
popd
pause
@GOTO END

:EMPTY
@ echo Empty target! Please assign a target path.
@ GOTO END

:END
