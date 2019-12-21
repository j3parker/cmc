FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y software-properties-common nginx && \
    add-apt-repository universe && \
    add-apt-repository ppa:certbot/certbot && \
    apt-get update && \
    apt-get install -y certbot python-certbot-nginx
