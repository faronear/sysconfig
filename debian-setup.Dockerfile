FROM debian:12.8
LABEL org.opencontainers.image.authors="luk"

RUN apt update && apt install curl -y
RUN curl -s https://git.tic.cc/npm/sysconfig/raw/branch/main/debian-setup.sh | bash

CMD bash

# mv $(basename $0) Dockerfile
# docker build -t debian-faronear .
# docker tag debian-faronear anolaxy/debian-faronear:11.5-20221205
# docker login
# docker push anolaxy/debian-faronear:11.5-20221205
# docker run -it anolaxy/debian-faronear:11.5-20221205 bash
