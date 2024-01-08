# Eoracle Operator Setup
This guide will walk you through the process of registering as an operator to Eoracle AVS and running the Eoracle software.

## Prerequisites
1. **Registered Eigenlayer Operator Account:** Ensure you have a fully registered Eigenlayer operator account. If you don't have one, follow the steps in the [Eigenlayer User Guide](https://docs.eigenlayer.xyz/restaking-guides/restaking-user-guide) to create and fund your account.

## Software/Hardware Requirement 
* Operating System: linux amd x64
* vCPUs: 2
* Memory: 4GiB 
* Storage: 100GB
* EC2 Equivalent: m5.large
* Expected Network Utilization:
  * Total download bandwidth usage: 1 Mbps
  * Upload bandwidth usage: 1 Mbps 
* Open Ports:
  * 3000 Grafana dashboards
  * 9090 Prometheus 

## Operator Setup
### ​Prepare Local Eoracle data fetcher files
Clone this [repo](https://github.com/Eoracle/Eoracle-operator-setup) and execute the following commands
```bash
git clone https://github.com/Eoracle/Eoracle-operator-setup.git
```
Edit the `Eoracle-operator-setup/data-fetcher/.env` and update the values for your setup

### Encrypt your private key
Encrypt your private key. The encrypted private key will be stored using at `ENCRYPTED_WALLET_PATH` 
```bash
cd Eoracle-operator-setup
./run.sh encrypt <your private key>
```

### Work with plain text private key
If you don't want to encrypt your private key. Add it to `data-fetcher/.private_key` file
```bash
PRIVATE_KEY=<your private key>
```

### Register to Eoracle AVS
Operators need to have a minimum of 32 ETH delegated to them to opt-in into Eoracle. Executes the following command 
```bash
cd Eoracle-operator-setup
./run.sh register
```

The output should looks like
```
Registering operator with address <your address> 
Opted into slashing with Service Manager at address 0x9546536FdAb1903e9c263923106eA5a4A44C4159
Registered Operator with Coordinator at address 0xd8eA2939cE17316b7CA2F86b121EB9c7c94c39c0 with tx hash 0x28b4b463762d917c514b0e0a5b6b8e65187a4ea43f2ab146672ba22d6b7aaa81
Awaiting finialization of registration
Awaiting finialization of registration
Sucessfully registered operator
```

### Checking status of Eoracle operator AVS
The following command will print the status of the operator
```bash
cd Eoracle-operator-setup
./run.sh print_status
```

The output should looks like
```
Using encrypted wallet
Running getOperator to read validator status
Registration status for 0x3fE88CAe88Bd08C15e1df8978a2E0F9547fb4e98: REGISTERED
Last Stake Update Block Number: 10338060 (Tue Jan 20 1970 17:30:55 GMT+0000 (Coordinated Universal Time))
Registered with 999 shares 
```


### Deregister from Eoracle AVS
The following command will unregister and opt-out you from the Eoracle AVS
```bash
cd Eoracle-operator-setup
./run.sh deregister
```
The output should looks like
```
Deregistering operator with address <your address> 
Deregistered Operator with Coordinator at address 0xd8eA2939cE17316b7CA2F86b121EB9c7c94c39c0 with tx hash 0x0c3016d0560c717f730a2b32446af242d66b83937cc015a02f0536fa41da1988
```

## Running Eoracle AVS Data Fetcher

### Run using docker
Run the docker
```bssh
cd Eoracle-operator-setup/data-fetcher
docker-compose up -d
```

The command will start the data fetcher container and if you do docker ps you should see an output indicating all containers have status of “Up” with ports assigned.
You may view the container logs using
```bash
docker logs -f <container_id>
```

The following example log messages confirm that your Eoracle data fetcher software is up and running
```
Starting data-fetcher 
<7> 2024-01-08T13:24:02.518Z info:      starting quotes listener
<7> 2024-01-08T13:24:02.600Z info:      starting polygon.io/forex feed
<7> 2024-01-08T13:24:02.602Z info:      starting polygon.io/crypto feed
<7> 2024-01-08T13:24:02.602Z info:      defaulting to process.env.PRIVATE_KEY for wallet
<7> 2024-01-08T13:24:02.656Z info:      Health endpoints are available through port: 10003
<7> 2024-01-08T13:24:02.657Z info:      Prometheus metrics are available through port: 10004
<7> 2024-01-08T13:24:02.714Z info:      starting quotes reporter
(node:7) ExperimentalWarning: The Fetch API is an experimental feature. This feature could change at any time
(Use `data-fetcher --trace-warnings ...` to show where the warning was created)
<7> 2024-01-08T13:24:02.886Z info:      polygon.io/forex: Subscribing to C.XAU/USD,C.XAG/USD,C.EUR/USD,C.AUD/USD,C.GBP/USD,C.JPY/USD
<7> 2024-01-08T13:24:03.191Z info:      polygon.io/crypto: Subscribing to XQ.BNB-USD,XQ.BTC-USD,XQ.ETH-USD,XQ.XRP-USD,XQ.ADA-USD,XQ.DOGE-USD,XQ.SOL-USD,XQ.TRX-USD,XQ.DOT-USD,XQ.MATIC-USD,XQ.LTC-USD
<7> 2024-01-08T13:24:03.985Z info:      sent block 62834 --- polygon.io/forex (3 symbols),polygon.io/crypto (9 symbols) ---transaction 0x85089592fdb1dd574a81b530c89db52372e86cf7a6ed4cd40654ccf2b157341a
<7> 2024-01-08T13:24:04.836Z info:      sent block 62835 --- polygon.io/forex (3 symbols),polygon.io/crypto (10 symbols) ---transaction 0xfbb53b3ae8e9f9e4f20490b4e117908fa6a2d690d32ca09093ae4bb57a135ecf
<7> 2024-01-08T13:24:06.078Z info:      sent block 62836 --- polygon.io/forex (3 symbols),polygon.io/crypto (10 symbols) ---transaction 0xc5751f1db8648e60a7d3c2071693124b9c4fff86428ae8bf61bb769b88501879
<7> 2024-01-08T13:24:06.959Z info:      sent block 62837 --- polygon.io/forex (3 symbols),polygon.io/crypto (10 symbols) ---transaction 0x0019a7b1bf387e83c66c6b02ebac5fbd116827bf2dc5ba5590fec178cda0c6d2
<7> 2024-01-08T13:24:07.716Z info:      polygon.io/crypto received ping
<7> 2024-01-08T13:24:07.717Z info:      polygon.io/forex received ping
<7> 2024-01-08T13:24:07.861Z info:      sent block 62838 --- polygon.io/forex (3 symbols),polygon.io/crypto (10 symbols) ---transaction 0x019394efa93031d614b1b4d65b819b5482bd14334fdd7e442b1e1757da5db504
<7> 2024-01-08T13:24:09.082Z info:      sent block 62839 --- polygon.io/forex (6 symbols),polygon.io/crypto (10 symbols) ---transaction 0xc3c636a2e0758db14f10085af9efccb1ba202b257962f6d417185aa78c651ceb
<7> 2024-01-08T13:24:09.966Z info:      sent block 62840 --- polygon.io/forex (6 symbols),polygon.io/crypto (10 symbols) ---transaction 0x8209b500f01ab405a18bfd80f213bb0e5716badd74326173823fdcc2dee6aaaa
<7> 2024-01-08T13:24:11.183Z info:      sent block 62841 --- polygon.io/forex (6 symbols),polygon.io/crypto (10 symbols) ---transaction 0x0191c5193e7cd4d1d2cdf1bdae1eb6bf3c12f09b04d111325c170a79b9dbc79c
<7> 2024-01-08T13:24:12.064Z info:      sent block 62842 --- polygon.io/forex (6 symbols),polygon.io/crypto (10 symbols) ---transaction 0xccc119cfb9a9e6a574fc4949b3c602de84fe75786728c557c92c7c29d94402c7
<7> 2024-01-08T13:24:12.608Z info:      polygon.io/forex received pong
<7> 2024-01-08T13:24:12.615Z info:      polygon.io/crypto received pong
<7> 2024-01-08T13:24:12.714Z info:      polygon.io/crypto received ping
<7> 2024-01-08T13:24:12.716Z info:      polygon.io/forex received ping
```

### Stop Eoracle data fetcher
To bring the containers down, run the following command
```bash
cd Eoracle-operator-setup/data-fetcher
docker compose down
```

### Upgrade Eoracle data fetcher
1. Upgrade the AVS software for your Eoracle data fetcher  by following the steps below:
2. Pull the latest repo
```bash
cd Eoracle-operator-setup/data-fetcher
git pull
```
3. Pull the latest docker images
```bash
docker compose pull
```
4. Stop the existing services
```bash
docker compose down
```
5. Start your services again
Make sure your .private_key file still has a correct value before you restart your node.
If there are any specific instructions that needs to be followed for any upgrade, those instructions will be given with the release notes of the specific release. Please check the latest release notes on Github and follow the instructions before starting the services again.
```bash
docker compose up -d
```

### Run using binary
// TODO

## Monitoring, Metrics, Grafana dashboards
### Quickstart
We provide a quickstart guide to run the Prometheus, Grafana, and Node exporter stack.
Checkout the README [here](monitoring/README.md) for more details. If you want to manually set this up, follow the steps below.

### Metrics
To check if the metrics are being emitted, run the following command:
```bash
curl http://localhost:<PROMETHEUS_PORT>/metrics
```

You should see something like
```
# HELP eigen_performance_score The performance metric is a score between 0 and 100 and each developer can define their own way of calculating the score. The score is calculated based on the performance of the Node and the performance of the backing services.
# TYPE eigen_performance_score gauge
eigen_performance_score{avs_name="EoracleDataFetcher"} 100
...
# HELP eoracle_health_check EOracle Health Check
# TYPE eoracle_health_check gauge
eoracle_health_check{avs_name="EoracleDataFetvher", name="service"} 1
eoracle_health_check{avs_name="EoracleDataFetvher", name="polygon.io"} 1
...
```

### Setup the monitoring stack 
These instructions provide a quickstart guide to run the Prometheus, Grafana, and Prometheus Node exporter stack.
Move your current working directory to the monitoring folder
```bash
cd Eoracle-operator-setup/data-fetcher/monitoring
```

#### Prometheus
We will use [prometheus](https://prometheus.io/download) to scrape the metrics from the EigenDA node.

Promtheus runs as part of the monitoring stack docker compose
* Make sure the prometheus port of Eoracle data fetcher is set correctly in the prometheus config file. 
You can find that in Eoracle data fetcher [.env](../.env) file (`PROMETHEUS_PORT`)

#### Grafana
We will use grafana to visualize the metrics from the EigenDA node.

You can use [OSS Grafana](https://grafana.com/oss/grafana/) for it or any other Dashboard provider.

You should be able to navigate to `http://localhost:3000` and login with `admin`/`admin`.
You will need to add a datasource to Grafana. You can do this by navigating to `http://localhost:3000/datasources` and adding a Prometheus datasource. By default, the Prometheus server is running on `http://localhost:9090`. You can use this as the URL for the datasource.

##### Useful Dashboards
We also provide a set of useful Grafana dashboards which would be useful for monitoring the Eoracle data fetcher service. You can find them [here](dashboards).
Once you have Grafana setup, feel free to import the dashboards.

#### Node exporter
Eoracle data fetcher emits Eoracle specific metrics but, it's also important to keep track of the node's health. For this, we will use [Node Exporter](https://prometheus.io/docs/guides/node-exporter/) which is a Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors.
Install the binary or use docker to [run](https://hub.docker.com/r/prom/node-exporter) it.

In Grafana dashboard, import the [node-exporter](dashboards/node-exporter.json) to see host metrics.

### Start the monitoring stack
You can start all the monitoring stack, Prometheus, Grafana, and Node exporter all in once or only specific component

```bash
docker-compose up -d
```

#### Connect docker networks
Since Eoracle data fetcher is running in a different docker network we will need to have the prometheus in the same network. To do that, run the following command
```bash
docker network connect eoracle-data-fetcher prometheus
```

### Troubleshooting
* If you see the following error:
    ```
    permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
    ```
    Use the same command by prepending `sudo` in front of it.
