FROM ethereum/client-go:alltools-release-1.8
USER root
RUN apk add --update-cache curl bash git supervisor nodejs \
    && rm -rf /var/cache/apk/*

RUN mkdir /netstats
WORKDIR /netstats

#RUN git clone https://github.com/cubedro/eth-net-intelligence-api api &&\
#    cd api &&\
#    npm install &&\
#    npm install -g pm2
#
#RUN git clone https://github.com/cubedro/eth-netstats
#    cd web && npm install
COPY api /netstats/api
COPY web /netstats/web
RUN pwd && cd /netstats/api &&\
    npm install &&\
    npm install -g pm2 && \
    cd /netstats/web && \
    npm install -g grunt && \
    npm install && \
    grunt
COPY rootfs /
COPY app.json /netstats/
EXPOSE 80

ENTRYPOINT ["/bin/entrypoint"]
