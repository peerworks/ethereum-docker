FROM ethereum/client-go:alltools-release-1.8
USER root
RUN apk add --update-cache curl bash git supervisor nodejs \
    && rm -rf /var/cache/apk/*
WORKDIR /netstats

RUN git clone https://github.com/cubedro/eth-net-intelligence-api api &&\
    cd api &&\
    npm install &&\
    npm install -g pm2

RUN git clone https://github.com/cubedro/eth-netstats web &&\
    cd web && npm install


COPY rootfs /
EXPOSE 80

ENTRYPOINT ["/bin/entrypoint"]
