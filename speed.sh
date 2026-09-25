speed() { curl -sS -o /dev/null -w "http=%{http_code} dns=%{time_namelookup}
  conn=%{time_connect} tls=%{time_appconnect} ttfb=%{time_starttransfer}
  total=%{time_total}\n" "$1"; }

speed "$1"
