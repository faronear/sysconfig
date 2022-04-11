echo Docker and Docker-Compose should be installed in prior.

git clone https://github.com/hyperledger/cello

cd cello

make api-engine

make docker-rest-agent

make dashboard

make start

docker container ls

echo Open http://localhost:8081
