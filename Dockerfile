FROM debian:latest
WORKDIR /app

COPY ./run-g6.php /app/run-g6.php
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt update && apt install -y \
    python3 python3-pip php-cli uvicorn openssh-server \
    supervisor

RUN apt-get install -y git
RUN chmod +x /app/run-g6.php && \
    mkdir -pv /var/run/sshd && echo 'root:g6env' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN git clone https://github.com/gnuboard/g6.git && mkdir -pv /app/volume && \
    cd /app/g6 && pip3 install -r requirements.txt --break-system-packages

EXPOSE 8000 22
ENTRYPOINT ["/usr/bin/supervisord"]