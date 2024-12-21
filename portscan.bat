@ if not "" == "%1" (
  set PORT=%1
) else (
  echo ::*** Enter [port] to scan:
  set /p PORT=">>> "
  echo;
)

netstat -aon |findstr %PORT%

@echo;

@echo "tasklist |findstr [PID]": to find the process, 
@echo "taskkill /T /F /PID [PID]": to kill the process.