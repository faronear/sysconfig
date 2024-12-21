@REM 在 powershell 里，只要 ssr 打开全局模式，不需要设置 proxy 就可以。
@REM 在 cmd 里，需要设置 proxy 才可以。

echo ::*** Enter [s] to start, [t] to terminate or [anything else] for no change
set /p TODOMODE=">>> "
echo;
if "s" == "%TODOMODE%" (
  set all_proxy=socks5://127.0.0.1:1080
  echo "--- 已开启网络代理"
) else if "t" == "%TODOMODE%" (
  set all_proxy=
  set http_proxy=
  set https_proxy=
  echo "--- 已关闭网络代理"
) else (
  echo No change.
)

@REM 测试 ip.gs, ip.sb, ipinfo.io
curl ipinfo.io


@REM set HTTP_PROXY=socks5://127.0.0.1:1080
@REM set HTTP_PROXY_USER=username
@REM set HTTP_PROXY_PASS=password

@REM set HTTPS_PROXY=socks5://127.0.0.1:1080
@REM set HTTPS_PROXY_USER=username
@REM set HTTPS_PROXY_PASS=password

