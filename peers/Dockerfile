FROM ethereum/client-go:alltools-release-1.8
USER root
WORKDIR /ethereum

VOLUME /ethereum/data

COPY genesis.json /ethereum/
COPY entrypoint /bin/entrypoint

ENTRYPOINT ["/bin/entrypoint"]

