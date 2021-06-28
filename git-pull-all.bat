@ IF "%1" == "" echo Using current folder as root folder

pushd %1
for /d %%d in (*) do pushd %%d & (for /d %%d in (*) do pushd %%d & echo Git Pulling %%d ... & git pull & popd) & popd
popd
@GOTO END

:EMPTY
@ echo Empty target! Please assign a target path.
@ GOTO END

:END
