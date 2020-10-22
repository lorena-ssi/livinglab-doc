# Description

This is the documentation to deploy a substrate regulator node on the Livinglab Testnet 

# Requirements

- Knowledge about Docker, Kubernetes and Helm
- Kubernetes cluster deployed
- A Kubernetes Storage Provider configured. *CaelumLabs recommends `SSD Storage` and you should enable K8S `allowVolumeExpansion` if is possible*
- Kubectl [installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Helm v3 [installed](https://helm.sh/docs/intro/install/)

# Installation

## Connect to the Kubernetes cluster using kubectl

```bash
kubectl config use-context OUR_KUBERNETES_CONTEXT;
```

## Configure the Lorena Helm repository 

```bash

# Add the Lorena Helm repository
$ helm repo add lorena https://lorena-helm-charts.storage.googleapis.com

# Ensure that the repo exists
$ helm repo list
lorena-helm-charts    https://lorena-helm-charts.storage.googleapis.com

# Update the repo to get the last Charts versions
$ helm repo update

```

# Run the Livinglab node

## Create your Helm values file

Copy the output of the command below into a values YAML file

```bash

$ helm show values lorena/livinglab-node > values.yaml

```

Output example:

```
# Default values for Livinglab node Chart.
# This is a YAML-formatted file.
# Declaring variables to be passed into Livinglab templates.

Namespace: livinglabs-demo

Substrate:
  # The substrate role of the node to deploy (Values accepted: regulator)
  Role: regulator
  # Chain values provided by Substrate: staging, local, dev
  # If you don't specify one of these values, you should add the specFile name to use for your custom chain
  # Chain name
  Chain: livinglab-testnet
  # Specfile with the non relative Path
  SpecFile: ./specfiles/livinglab-testnet-specfileRaw.json
  
  # Substrate Base path, by default /data will be used
  # DataDir: /data
  
  # NodeName: Using the release name

  # If you want scrape the substrate metrics from Prometheus, set the value to true
  Prometheus:
    # Prometheus StatefulSet annotations will be setted automatically if you enable Substrate Prometheus 
    Enabled: false
    Port: "9615"
  Peers:
    # List of bootnodes to connect from the node that will be deployed
    Bootnodes:
      # - /ip4/nodeIP/tcp/nodePort/p2p/nodeP2PAddress
      # - /ip4/node2IP/tcp/node2Port/p2p/node2P2PAddress
      # Caelumlabs Livinglab Bootnode
      - /ip4/35.241.221.239/tcp/30333/p2p/12D3KooWK9hPFDuGdTw9KMpVdpHJZS79EzBjwAQFeAE2o3ZPQHHt


StatefulSet:
  Labels: 
    project: LivingLab
    env: test
    tech: substrate
    network: livinglab-testnet
  Annotations:
  Image:
    Repository: eu.gcr.io/caelumlabs-hub01/substrate-apps/substrate-v2-livinglab
    # Overrides the image tag whose default is the chart appVersion.
    Tag: test_latest
    PullPolicy: IfNotPresent
  Resources:
    Limits:
      cpu: 2
      memory: 512M
    Requests:
      cpu: 0.1
      memory: 128M
    # A Kubernetes persistent storage class is required and 
    # should be already deployed on your cluster
    # Recommendations for the Storage Class definition:
    # enable allowVolumeExpansion
    # use SSD storage
  VolumeClaimTemplates:
    StorageClassName: gke-ssd
    ResourcesRequestStorage: 60Gi
Service:
  Regulator:
    Type: Nodeport
    # Port: 9946
    # TargetPort: 9944
```

## Customize your node ensuring these values are setted into values file:

- **Namespace**
  - Description: The Kubernetes namespace where the resources will be deployed
  - Value to set: `your Kubernetes namespace`

- **Substrate:Role**
  - Description: The node role on the network
  - Value to set: `regulator`
  
- **Substrate:Chain**
  - Description: The Substrate network name where the node will connect 
  - Value to set: `livinglab-testnet`

- **Substrate:SpecFile**
  - Description: The Substrate SpecFile with the specifications of the chain specified above 
  - Value to set: `./specfiles/livinglab-testnet-specfileRaw.json`

- **Substrate:Peers:Bootnodes**
  - Description: The Livinglab bootnode where the node will connect to discover other network nodes. This one is provided by CaelumLabs 
  - Value to set: `/ip4/35.241.221.239/tcp/30333/p2p/12D3KooWK9hPFDuGdTw9KMpVdpHJZS79EzBjwAQFeAE2o3ZPQHHt`

- **StatefulSet:Image:Repository**
  - Description: The Docker Registry URI and Docker Image Name that provides the Livinglab Docker image to deploy. This one is managed and maintained by CaelumLabs 
  - Value to set: `eu.gcr.io/caelumlabs-hub01/substrate-apps/substrate-v2-livinglab`

- **StatefulSet:Image:Tag**
  - Description: The Docker image version to deploy  
  - Value to set: `v2.0.0-rc6-v1.0.6`

- **StatefulSet:Resources:Limits**
  - Description: The maximum cpu and memory resources that the container will be consume into Kubernetes  
  - Value to set: `the values you want,the minimal required values are setted by default`

- **StatefulSet:Resources:Requests**
  - Description: The minimal cpu and memory resources needed by the container to run into Kubernetes   
  - Value to set: `the values you want,the minimal required values are setted by default`

- **StatefulSet:VolumeClaimTemplates:StorageClassName**
  - Description: The Storage Provider Class for your Kubernetes cluster 
  - Value to set: `your Kubernetes Storage Class Name`

- **StatefulSet:VolumeClaimTemplates:ResourcesRequestStorage**
  - Description: The Substrate data disk size for your node  
  - Value to set: `your disk size`

## Deploy the node

*Note: Please, change these string on the commands below by your custom value*

- yourHelmDeploymentName
- namespaceWhereReleaseInfoIsSavedAndNodeDeployed
- yourValuesFile

### First of all with `dry-run` mode to validate the Helm Chart and the values you are setted

```bash
# Dry run mode
helm upgrade yourHelmDeploymentName lorena/livinglab-node --install --wait --atomic --namespace namespaceWhereReleaseInfoIsSavedAndNodeDeployed --create-namespace -f yourValuesFile --dry-run
```

### Deploy
```bash
# Deploy the node
helm upgrade yourHelmDeploymentName lorena/livinglab-node --install --wait --atomic --namespace namespaceWhereReleaseInfoIsSavedAndNodeDeployed --create-namespace -f yourValuesFile 
```

# Upgrade the Livinglab node version (helm chart version):

## Update the Lorena Helm repository and get the last version available

```bash

# Update the repo to get the last Charts versions
$ helm repo update

```

## Get the last version available from the Lorena Repository

```bash

# Show the last version availble
$ helm show chart lorena/livinglab-node
apiVersion: v2
appVersion: 2.0.0-rc6
description: Livinglab Regulator node
name: livinglab-node
type: application
version: 0.1.1

```
## Upgrade the node

*Note: Please, change these string on the commands below by your custom value*

- yourHelmDeploymentName
- namespaceWhereReleaseInfoIsSavedAndNodeDeployed
- yourValuesFile

### First of all with `dry-run` mode to validate the Helm Chart and the values you are setted

```bash
# Dry run mode
helm upgrade yourHelmDeploymentName lorena/livinglab-node --install --wait --atomic --namespace namespaceWhereReleaseInfoIsSavedAndNodeDeployed --version helmChartVersionToDeploy -f yourValuesFile --dry-run
```

### Deploy
```bash
# Deploy the node
helm upgrade yourHelmDeploymentName lorena/livinglab-node --install --wait --atomic --namespace namespaceWhereReleaseInfoIsSavedAndNodeDeployed --version helmChartVersionToDeploy -f yourValuesFile
```

# Monitoring Tools

- Polkadot JS - Blockchain Explorer : https://polkadot.js.org/apps/#/explorer
- Telemetry - Nodes Explorer: https://telemetry.polkadot.io/#list/Livinglabs%20Testnet
