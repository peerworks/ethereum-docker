FROM tzion/peer 
USER root
RUN apk add --update-cache curl bash git supervisor nodejs \
    && rm -rf /var/cache/apk/*

RUN mkdir /netstats

VOLUME /ethereum/data
COPY genesis.json /ethereum/

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


RUN cd /netstats/web && \
    npm install -g grunt && \
    npm install && \
    grunt
RUN cd /netstats/api &&\
    npm install -g pm2 && \
    npm install
COPY rootfs /
COPY app.json /netstats/
EXPOSE 80

ENTRYPOINT ["/bin/entrypoint"]
