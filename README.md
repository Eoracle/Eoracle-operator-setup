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
### ​Prepare Local Eoracle data validator files
Clone this [repo](https://github.com/Eoracle/Eoracle-operator-setup) and execute the following commands
```bash
git clone https://github.com/Eoracle/Eoracle-operator-setup.git
cd Eoracle-operator-setup
cp data-validator/.example_env data-validator/.env
```
Edit the `data-validator/.env` and update the values for your setup

### Encrypt your private key (recommended)
Encrypt your private key. The encrypted private key will be stored using at `ENCRYPTED_WALLET_PATH`   
This is the recommended approach. if you encrypt a pasted private key it will never be saved as is anywhere.
```bash
./run.sh encrypt <your private key>
```

### Work with plain text private key (discouraged)
If you don't want to encrypt your private key, update it in the `data-validator/.env` file  
This approach is highly discouraged. We recommend encrypting the private key and never saving it anywhere on any machine.  
```bash
PRIVATE_KEY=<your private key>
```

### Register with Eoracle AVS
Operators need to have a minimum of 32 ETH delegated to them to opt-in to Eoracle. Execute the following command 
```bash
./run.sh register
```

The output should look like
```
Registering operator with address <your address> 
Opted into slashing with Service Manager at address 0x9546536FdAb1903e9c263923106eA5a4A44C4159
Registered Operator with Coordinator at address 0xd8eA2939cE17316b7CA2F86b121EB9c7c94c39c0 with tx hash 0x28b4b463762d917c514b0e0a5b6b8e65187a4ea43f2ab146672ba22d6b7aaa81
Awaiting finalization of registration
Awaiting finalization of registration
.
.
.
Awaiting finalization of registration
Successfully registered operator
```

### Checking the status of Eoracle operator AVS
The following command will print the status of the operator
```bash
./run.sh print_status
```

The output should look like
```
Using encrypted wallet
Running getOperator to read validator status
Registration status for 0x3fE88CAe88Bd08C15e1df8978a2E0F9547fb4e98: REGISTERED
Last Stake Update Block Number: 10338060 
Registered with 999 shares 
```

### Deregister from Eoracle AVS
The following command will unregister and opt you out of the Eoracle AVS
```bash
cd Eoracle-operator-setup
./run.sh deregister
```
The output should look like
```
Deregistering operator with address <your address> 
Deregistered Operator with Coordinator at address 0xd8eA2939cE17316b7CA2F86b121EB9c7c94c39c0 with tx hash 0x0c3016d0560c717f730a2b32446af242d66b83937cc015a02f0536fa41da1988
```

## Running Eoracle AVS data validator

### Run using docker
Run the docker
```bash
cd data-validator
docker compose up -d
```

The command will start the data validator container, and if you execute `docker ps` you should see an output indicating all containers have the " Up " status with ports assigned.
You may view the container logs using
```bash
docker logs -f <container_id>
```

The following example log messages confirm that your Eoracle data validator software is up and running
```sh
Starting data-validator 
<7> 2024-01-08T13:24:02.518Z info:      starting quotes listener
<7> 2024-01-08T13:24:02.600Z info:      starting polygon.io/forex feed
<7> 2024-01-08T13:24:02.602Z info:      starting polygon.io/crypto feed
<7> 2024-01-08T13:24:02.602Z info:      defaulting to process.env.PRIVATE_KEY for wallet
<7> 2024-01-08T13:24:02.656Z info:      Health endpoints are available through port: 10003
<7> 2024-01-08T13:24:02.657Z info:      Prometheus metrics are available through port: 10004
<7> 2024-01-08T13:24:02.714Z info:      starting quotes reporter
(node:7) ExperimentalWarning: The Fetch API is an experimental feature. This feature could change at any time
(Use `data-validator --trace-warnings ...` to show where the warning was created)
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

### Stop Eoracle data validator
To bring the containers down, run the following command
```bash
cd Eoracle-operator-setup/data-validator
docker compose down
```

### Upgrade Eoracle data validator
Upgrade the AVS software for your Eoracle data validator by following the steps below:  
1. Pull the latest repo
```bash
cd Eoracle-operator-setup
git pull
```
2. Merge .env changes  
Go over .example_env and merge new fields that do not appear in your local .env file

3. Pull the latest docker images
```bash
cd data-validator
docker compose pull
```
4. Stop the existing services
```bash
docker compose down
```
5. Start your services again
If any specific instructions need to be followed for any upgrade, those instructions will be given with the specific release notes. Please check the latest [release notes](https://github.com/Eoracle/Eoracle-operator-setup/releases) on Github and follow the instructions before starting the services again.
```bash
docker compose up -d
```

## Monitoring, Metrics, Grafana dashboards
### Quickstart
We provide a quick start guide to run the Prometheus, Grafana, and Node exporter stack.
Check out the README [here](data-validator/monitoring/README.md) for more details. If you want to manually set this up, follow the steps below.

### Metrics
To check if the metrics are being emitted, run the following command:
Replace the `PROMETHEUS_PORT` with the value of `PROMETHEUS_PORT` from the `data-validator/.env`  
```bash
curl http://localhost:<PROMETHEUS_PORT>/metrics
```

You should see something like
```
# HELP eigen_performance_score The performance metric is a score between 0 and 100 and each developer can define their own way of calculating the score. The score is calculated based on the performance of the Node and the performance of the backing services.
# TYPE eigen_performance_score gauge
eigen_performance_score{avs_name="EoracleDataValidator"} 100
...
# HELP eoracle_health_check EOracle Health Check
# TYPE eoracle_health_check gauge
eoracle_health_check{avs_name="EoracleDataValidator", name="service"} 1
eoracle_health_check{avs_name="EoracleDataValidator", name="polygon.io"} 1
...
```

### Setup the monitoring stack 
We use [prometheus](https://prometheus.io/download) to scrape the metrics from the Eoracle data validator container.
Make sure to edit the [prometheus.yml](data-validator/monitoring/prometheus.yml) file, located at Eoracle-operator-setup/data-validator/monitoring, replacing the placeholder 'PROMETHEUS_PORT' with the actual value specified in the data validator [.env](data-validator/.env) file (PROMETHEUS_PORT)
```bash
cd Eoracle-operator-setup/data-validator/monitoring
```

The relevant lines are:
```yml
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 1m
    static_configs:
      - targets: ['eoracle-data-validator:<PROMETHEUS_PORT>']
```

### Start the monitoring stack
You can start all the monitoring stack, Prometheus, Grafana, and Node exporter all at once or only specific component

```bash
docker compose up -d
```

### Connect docker networks
Since the Eoracle data validator is running in a different docker network, we will need to have the Prometheus container in the same network of oracle-data-validator. To do that, run the following command. To do that, run the following command
```bash
docker network connect eoracle-data-validator prometheus
```

### Troubleshooting
* If you see the following error:
    ```
    permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
    ```
    Use the same command by prepending `sudo` in front of it.

### Grafana
We use Grafana to visualize the metrics from the Eoracle AVS.

You can use [OSS Grafana](https://grafana.com/oss/grafana/) for it or any other Dashboard provider.

You should be able to navigate to `http://<ip>:3000` and log in with `admin`/`admin`.
This container of Grafana has a Prometheus datasource setup using port 9090.  If you change the Prometheus port, you need to add a new data source or update the existing data source. 
You can do this by navigating to `http://<ip>:3000/datasources`

##### Useful Dashboards
We also provide a set of useful Grafana dashboards which would be useful for monitoring the Eoracle data validator service. You can find them [here](data-validator/dashboards).
Once you have Grafana set up, feel free to import the dashboards.

### Node exporter
Eoracle data validator emits Eoracle specific metrics but, it's also important to keep track of the node's health. For this, we will use [Node Exporter](https://prometheus.io/docs/guides/node-exporter/) which is a Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors.
By default, it is installed and started when you start the entire monitoring stack. If you want to modify the stack, you can install the binary or use docker to [run](https://hub.docker.com/r/prom/node-exporter).

In Grafana dashboards screen, import the [node-exporter](dashboards/node-exporter.json) to see host metrics.
