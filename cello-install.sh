echo Docker and Docker-Compose should be installed in prior.
echo [202205] 发现必须下载版本，不能用最新代码，否则无法安装成功。
git clone -b v1.0.0-alpha https://github.com/hyperledger/cello

cd cello

make api-engine

make docker-rest-agent

make dashboard

make start

docker container ls

echo Open http://localhost:8081
