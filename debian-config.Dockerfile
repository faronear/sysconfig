FROM debian:11.5
LABEL org.opencontainers.image.authors="luk"

RUN apt update && apt install curl -y
RUN curl https://git.faronear.org/fon/sysconfig/raw/branch/main/debian-config.sh > ~/debian-config.sh && echo -e "l\n\n\n\n\n" | bash ~/debian-config.sh

CMD bash
