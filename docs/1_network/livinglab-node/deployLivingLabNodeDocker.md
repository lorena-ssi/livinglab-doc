# Description

Step by step guide to deploy LivingLab node without Kubernetes, only using Docker Engine

> This is not the recommended way to deploy the node, but is usefull as a Dev or local deployment. Caelumlabs recommends [the Kubernetes deployment.](https://doc.livinglab.caelumlabs.com/1_network/livinglab-node/deployLivingLabNode.html)

# Installation

## Install docker

[Documentation]: https://docs.docker.com/install
[Post Installation]: https://docs.docker.com/install/linux/linux-postinstall/

```bash
sudo apt-get update
sudo apt install docker.io
sudo systemctl start docker
docker --version
```

If you don’t want to preface the docker command with sudo, create a Unix group called docker and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group.

```bash
sudo groupadd docker
sudo usermod -aG docker

# logout & login
```

* Download CaelumLabs LivingLab Node Docker image

```bash
# This command uses the "latest" version of the image, you can put the image you want
docker pull eu.gcr.io/caelumlabs-hub01/substrate-apps/substrate-v2-livinglab:latest
```

# Deploy

# Run your own node

Before run the node, you should **change the value of the parameters DOCKER_NAME,DATA_DIR and NODE_NAME** 

**DOCKER_NAME:** is the name for your docker container
**DATA_DIR:** the blockchain data storage directory
**NODE_NAME:** The livinglab node name

```
docker run --rm -it -p 30333:30333/tcp -p 30333:30333/udp -p 9944:9944/tcp \
  --name DOCKER_NAME eu.gcr.io/caelumlabs-hub01/substrate-apps/substrate-v2-livinglab:latest \
  --chain ./specfiles/livinglab-testnet-specfileRaw.json  \
  --base-path DATA_DIR \
  --name NODE_NAME \
  --bootnodes /ip4/35.241.221.239/tcp/30333/p2p/12D3KooWK9hPFDuGdTw9KMpVdpHJZS79EzBjwAQFeAE2o3ZPQHHt \
  --unsafe-ws-external \
  --rpc-cors \
  all

```

# Monitoring Tools

- Polkadot JS - Blockchain Explorer : https://polkadot.js.org/apps/#/explorer
- Telemetry - Nodes Explorer: https://telemetry.polkadot.io/#list/Livinglabs%20Testnet
