FROM debian:11.5
LABEL org.opencontainers.image.authors="luk"

RUN apt update && apt install curl -y
RUN curl https://git.faronear.org/npm/sysconfig/raw/branch/main/debian-setup.sh > ~/debian-setup.sh && echo -e "l\n\n\n\n\n" | bash ~/debian-setup.sh

CMD bash

# docker build -t debian-faronear .
# docker tag debian-faronear anolaxy/debian-faronear:11.5-20221205
# docker login
# docker push anolaxy/debian-faronear:11.5-20221205
# docker run -it anolaxy/debian-faronear:11.5-20221205 bash
