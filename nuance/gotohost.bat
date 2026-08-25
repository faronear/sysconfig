@ IF "%1" == "" GOTO EMPTY
@ IF "%1" == "home" GOTO HOME
@ IF "%1" == "office" GOTO OFFICE
@ IF "%1" == "aachen" GOTO AACHEN
@ IF "%1" == "xena" GOTO XENA
@ IF "%1" == "grid" GOTO GRID
@ IF "%1" == "menlo" GOTO MENLO

:UNKNOWN
@ echo Unknown target!
@ ssh -C -X %1
@ GOTO END

:EMPTY
@ echo Empty target!
@ echo Usage: gotohost [TARGET]
@ echo   TARGET = home, aachen, xena, grid, menlo
@ echo Example: gotohost grid
@ GOTO END

:HOME
@ ssh -C -X Administrator@nil.sytes.net
@ GOTO END

:OFFICE
@ ssh -C -X leiqin@leiqin.eu.scansoft.com
@ GOTO END

:AACHEN
@ ssh -C -X leiqin@ac-green.eu.scansoft.com
@ GOTO END

:XENA
@ ssh -C -X llu@xena.speechworks.com
@ GOTO END

:GRID
@ ssh -C -X llu@grid-cnh8.grid.nuance.com
@ GOTO END

:MENLO
@ ssh -C -X lleiqin@navy.nuance.com
@GOTO END

:END
