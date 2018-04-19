#!/bin/bash
/usr/local/bin/geth --networkid=331788 --bootnodes="enode://f5e80a12c9aa63ba2ce96d03c13eaf2bafd295f62383feb0af383d29a0c7d78c80049fd63671e703564b400b890e5e1afabece47939883cc8723ffd14976ab6a@172.16.238.10:30301" --rpc --rpcaddr="0.0.0.0" --rpcapi="db,eth,net,web3,personal" --rpccorsdomain="*" --cache=200 --verbosity=5 --port=30305 node
