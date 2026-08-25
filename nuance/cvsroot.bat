@ IF "%1" == "" GOTO EMPTY
@ IF "%1" == "p" GOTO PRODUCT
@ IF "%1" == "s" GOTO SOLUTION
@ IF "%1" == "a" GOTO ASR
@ IF "%1" == "o" GOTO OFFICE
@ IF "%1" == "h" GOTO HOME

:UNKNOWN
@ echo Unknown option! Nothing was configured.
@ GOTO USAGE

:EMPTY
@ echo Empty option! Nothing was configured.
@ GOTO USAGE

:USAGE
@ echo Usage: cvsroot [psaoh]
@ echo   p, s, a for Product/Solutions/AMR
@ echo   o, h for my Office/Home
@ echo Example: cvsroot o
@ GOTO END

:PRODUCT
@ set CVSROOT=:pserver:llu@cvshost.speechworks.com:/swicvs/product
@ echo CVSROOT of Product was successfully configured.
@ GOTO END

:SOLUTION
@ set CVSROOT=:pserver:llu@cvshost.speechworks.com:/swicvs/solutions
@ echo CVSROOT of Solutions was successfully configured.
@ GOTO END

:ASR
@ set CVSROOT=:pserver:llu@wa-csr-cvs.wa.scansoft.com:/res/lvcsr/code/cvsroot
@ echo CVSROOT of AMR was successfully configured.
@ GOTO END

:OFFICE
@ set CVSROOT=:ext:llu@ac-llu.nuance.com:/cygdrive/c/Home/cvsrep
@ echo CVSROOT of Office was successfully configured.
@ GOTO END

:HOME
@ set CVSROOT=:ext:llu@nil.sytes.net:/cygdrive/r/cvsrep
@ echo CVSROOT of Home was successfully configured.
@GOTO END

:END
