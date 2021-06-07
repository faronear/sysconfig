@ REM Return if option is empty or invalid:
@ IF "%1" == "" GOTO EMPTY
@ IF NOT EXIST %HOME%\products\%1 GOTO EMPTY

@ set PATH=%HOME%\products\%1\bin;%PATH%
@ set PRODUCT_LIB_PREFIX=SR
@ set CORE_ROOT=%HOME%\products\%1
@ set SWISDK=%HOME%\products\%1
@ set SWISRSDK=%HOME%\products\%1
@ set SWILicenseServerList=27000@ac-albatross;27000@juelich;27000@ac-birdie
@ GOTO END

:EMPTY
@ echo Unknown option! Nothing was configured.
@ echo Usage: osr VERSION
@ echo Example: osr osr309
@ GOTO END

:END
