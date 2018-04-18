# 以太坊自有链搭建
## 原理
如果节点没有连接到以太坊主网的节点，统称为私有网络。私有的更确切的语义应该是：隔离, 预留。区块链是一个分布式的对等网络，所有的节点基于同样的协议才能进行正常的通信。对于以太坊来说，所有的节点能够通信的前提是同一个协议版本和同一个网络ID。通过自定义网络ID 可以部署自己的私有的以太坊网络。
## 步骤
### 生成创世区块
所有使用同样创世区块的节点组成了一个区块链网络

~~~json
{
  "config": {
    "chainId": 1991,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
    "alloc"      : {
       "0x0000000000000000000000000000000000000000": {"balance": "100000"}
  },
  "coinbase"   : "0x0000000000000000000000000000000000000000",
  "difficulty" : "0x20000",
  "extraData"  : "",
  "gasLimit"   : "0x2fefd8",
  "nonce"      : "0xeddeadbabeeddead",
  "mixhash"    : "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash" : "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp"  : "0x00"
}
~~~
### 启动第一个节点bootnode（类似于注册中心）
在整个分布式系统中，我们如何知道彼此在哪里？在所有节点启动的时候，默认的都会去连接指定的一些节点，用来告诉大家新的节点上线了，或者获取到当前网络中还有那些节点。

```bash
mkdir bootnode
# 以太坊由无数的节点组成。我们需要Identifier 来标示和区别不同的节点。Identifier 通过key 计算生成。
# 生成唯一标示的key
docker run --rm \
        -v $(pwd)/bootnode:/opt/bootnode \
        ethereum/client-go:alltools-stable bootnode --genkey /opt/bootnode/boot.key
# 启动bootnode
docker run -d --name ethereum-bootnode \
    -v $(pwd)/bootnode:/opt/bootnode \
    -p 0.0.0.0:30301:30301/tcp \
    -p 0.0.0.0:30301:30301/udp \
    ethereum/client-go:alltools-release-1.8 bootnode \
    --nat=none \
    --nodekey /opt/bootnode/boot.key \
    --verbosity=9 --addr="0.0.0.0:30301"
# 获取bootnode 的唯一标识. bootnode 启动的时候，会在终端输出当前bootnode的唯一标识
# INFO [04-18|05:53:58] UDP listener up     self=enode://7654b32fdbac6d3567855346656b1e23146bf5157bd00e1ccca9e2ac278c5060c2c9197426fc18a63cae9e814bae9d8284afebb1952aea03bd4145c779bb0096@[::]:30301
# 将[::]替换为当前bootnode的public IP 即为当前节点的唯一地址
docker logs -f ethereum-bootnode
```
### 启动其他节点

```bash
mkdir node1
# 初始化节点配置
docker run --rm \
    -v $(pwd)/node1:/root/.ethereum \
    -v $(pwd)/genesis.json:/opt/genesis.json \
    ethereum/client-go init /opt/genesis.json
# 启动节点
docker run -d --name node1 \
    -v $(pwd)/node1:/root/.ethereum \
    -v $(pwd)/ethash/node1:/root/.ethash \
    -v $(pwd)/genesis.json:/opt/genesis.json \
    -p 0.0.0.0:30303:30303/tcp \
    -p 0.0.0.0:30303:30303/udp \
    -p 0.0.0.0:8485:8545/tcp \
    -p 0.0.0.0:8485:8545/udp \
    ethereum/client-go:alltools-release-1.8 \
    geth --networkid=456719 \
    --bootnodes=enode://7654b32fdbac6d3567855346656b1e23146bf5157bd00e1ccca9e2ac278c5060c2c9197426fc18a63cae9e814bae9d8284afebb1952aea03bd4145c779bb0096@206.189.81.91:30301 \
    --rpc --rpcaddr=0.0.0.0 --rpcapi=db,eth,net,web3,personal --rpccorsdomain "*" \
     --cache=200 --verbosity=4 --maxpeers=3 --port=30303 node1
```