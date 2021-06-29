@echo off

@ IF "%1" == "" echo Using current folder as root folder

pushd %1
for /d %%d in (*) do pushd %%d & (for /d %%d in (*) do if exist %%d/package.json (pushd %%d & echo [ npm booting %%d ... ] & npm run boot & popd)) & popd
popd
pause
@GOTO END

:EMPTY
@ echo Empty target! Please assign a target path.
@ GOTO END

:END
