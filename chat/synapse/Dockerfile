FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y build-essential python3-dev libffi-dev \
                       python3-pip python3-setuptools sqlite3 \
                       libssl-dev python3-virtualenv libjpeg-dev \
                       libxslt1-dev python3-lxml

RUN pip3 install --upgrade setuptools && \
    pip3 install matrix-synapse

RUN groupadd -g 1337 synapse && useradd -m -u 1337 -g synapse synapse
USER synapse
WORKDIR /home/synapse

COPY cmc.rip.log.config ./
COPY --chown=synapse homeserver.yaml ./
COPY boot.sh ./

ENTRYPOINT ["/home/synapse/boot.sh"]
