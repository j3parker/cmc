FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y build-essential python3-dev libffi-dev \
                       python3-pip python3-setuptools sqlite3 \
                       libssl-dev python3-virtualenv libjpeg-dev libxslt1-dev

RUN pip3 install --upgrade setuptools && \
    pip3 install matrix-synapse

RUN useradd -u 1337 synapse
USER synapse
WORKDIR /home/synapse

COPY cmc.rip.log.config ./
COPY homeserver.yaml ./
