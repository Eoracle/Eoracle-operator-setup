# eoracle Operator Setup
This guide will walk you through the process of registering as an operator to eoracle AVS and running the eoracle software.

## Prerequisites
1. **Registered Eigenlayer Operator Account:** Ensure you have a fully registered Eigenlayer operator account. If you don't have one, follow the steps in the [Eigenlayer User Guide](https://docs.eigenlayer.xyz/restaking-guides/restaking-user-guide) to create and fund your account.
2. **Activate as eoracle operator:** Ensure eoracle activated your account. In order to check your current status you can run the following through [foundry](https://book.getfoundry.sh/getting-started/installation) (1 is activated, 0 is not). In case of issues please contact support@eoracle.io
```bash
cast call <EOConfig_Address> "isValidatorActive(address validator)" <your_operator_address> -r https://rpc.eoracle.network | cast 2d
```

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
### ​Prepare Local eoracle data validator files
Clone this [repo](https://github.com/Eoracle/Eoracle-operator-setup) and execute the following commands
```bash
git clone https://github.com/Eoracle/Eoracle-operator-setup.git
cd Eoracle-operator-setup
cp data-validator/.example_env data-validator/.env
```
Copy `Eoracle-operator-setup/data-validator/.example_env` into `Eoracle-operator-setup/data-validator/.env`.  
Edit the `Eoracle-operator-setup/data-validator/.env` and update the values for your setup

### Generate a BLS pair (recommended)
The register process requires two sets of private keys: an ecdsa private key and a bls private key,  
We recommend creating a new BLS pair for security reasons.
If you want to create a new BLS pair, you can generate a new BLS pair that will be dedicated to eoracle
```bash
./run.sh generate-bls-key
```

### Encrypt your private keys (recommended)
Encrypt your private keys. The encrypted private keys will be stored using the `EO_KEYSTORE_PATH` field.
This is the recommended approach. if you encrypt a pasted private key it will never be saved as is anywhere.
```bash
./run.sh encrypt <your ecdsa private key> <your bls private key>
```

### Work with plain text private keys (discouraged)
If you don't want to encrypt your private keys, update them in the `data-validator/.env` file  
This approach is highly discouraged. We recommend encrypting the private keys and never saving them anywhere on any machine.  
```bash
EO_BLS_PRIVATE_KEY=<your ecdsa private key>
EO_ECDSA_PRIVATE_KEY=<your bls private key>
```

### Register with eoracle AVS
Operators need to have a minimum of 32 ETH delegated to them to opt-in to eoracle. Execute the following command 
```bash
./run.sh register
```

The output should look like
```
{"level":"info","ts":1712853423.629971,"caller":"logging/zap_logger.go:49","msg":"succesfully registered to eoracle AVS","address":"<your_address>","tx hash":"<your_tx_hash>"}
```
### Declare an eoracle alias 
Operators must declare another ECDSA address to use within the eoracle client. This isolates the Ethereum Eigenlayer operator private key from eoracle operations, protecting access to Ethereum assets. 
```
./run.sh eochain-set-alias
```
The output should look like 

```
alias ecdsa address  <your_alias_address> saved
{"level":"info","ts":1712869774.0857012,"caller":"logging/zap_logger.go:49","msg":"succesfully set the alias in the eochain","Ethereum address":"<your_ethereum_address>","eochain address":"<your_alias_address>","tx hash":"<tx_hash>"}
```

This generates an alias ECDSA keypair, encrypts and stores it in the keystore. Importing and plaintext is also enabled but discourged. 


```
❯ ls -la /path/to/keystore.keystore
-rw-r--r--@ 1 <usr>  staff  554 Apr 11 20:18 blsEncryptedWallet.json
-rw-r--r--  1 <usr>  staff  491 Apr 12 00:06 ecdsaAliasedEncryptedWallet.json
-rw-r--r--@ 1 <usr>  staff  491 Apr 11 20:18 ecdsaEncryptedWallet.json
```

Note: Access to our client source code is currently restricted, however, interested parties may contact support@eoracle.io to review the client for security reasons. 


### Troubleshooting the register command.
salt already spent - if you get the following error:
```
Failed to create RegisterOperator transaction execution reverted: AVSDirectory.registerOperatorToAVS: salt already spent
```
Please add EO_SALT=<salt_in_hex> field to your .env file and retry runnning register.  

(*) the EO_SALT should be in the following format EO_SALT=0x04 (even length hex number, and could be any number but must be even length)

### Checking the status of Eoracle operator AVS

The following command will print the status of the operator
```bash
./run.sh print-status
```

The output should look like
```
docker-entrypoint-oprcli.sh: Starting oprcli print-status 
{"level":"info","ts":1712824061.311895,"caller":"logging/zap_logger.go:49","msg":"Operator Status","status":"REGISTERED"}
{"level":"info","ts":1712824061.3466434,"caller":"logging/zap_logger.go:49","msg":"Operator stake update","stake":"<your_stake>","block number":1253026}
```


### Deregister from eoracle AVS
The following command will unregister and opt you out of the eoracle AVS

```bash
cd Eoracle-operator-setup
./run.sh deregister
```
The output should look like
```
Deregistering operator with address <your address> 
Deregistered Operator with Coordinator at address 0xd8eA2939cE17316b7CA2F86b121EB9c7c94c39c0 with tx hash 0x0c3016d0560c717f730a2b32446af242d66b83937cc015a02f0536fa41da1988
```

## Running eoracle AVS data validator

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

The following example log messages confirm that your eoracle data validator software is up and running
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

### Stop eoracle data validator
To bring the containers down, run the following command
```bash
cd Eoracle-operator-setup/data-validator
docker compose down
```

### Upgrade eoracle data validator
1. Upgrade the AVS software for your eoracle data validator  by following the steps below:
2. Pull the latest repo
```bash
cd Eoracle-operator-setup
git pull
```
3. Merge .env changes
Go over .example_env and merge new fields that do not appear in your local .env file

4. Pull the latest docker images
```bash
cd data-validator
docker compose pull
```
5. Stop the existing services
```bash
docker compose down
```
6. Start your services again
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
Replace the `EO_PROMETHEUS_PORT` with the value of `EO_PROMETHEUS_PORT` from the `data-validator/.env`  
```bash
curl http://localhost:<EO_PROMETHEUS_PORT>/metrics
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
We use [prometheus](https://prometheus.io/download) to scrape the metrics from the eoracle data validator container.
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
      - targets: ['eoracle-data-validator:<EO_PROMETHEUS_PORT>']
```

### Start the monitoring stack
You can start all the monitoring stack, Prometheus, Grafana, and Node exporter all at once or only specific component

```bash
docker compose up -d
```

### Connect docker networks
Since the eoracle data validator is running in a different docker network, we will need to have the Prometheus container in the same network of oracle-data-validator. To do that, run the following command. To do that, run the following command
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
We use Grafana to visualize the metrics from the eoracle AVS.

You can use [OSS Grafana](https://grafana.com/oss/grafana/) for it or any other Dashboard provider.

You should be able to navigate to `http://<ip>:3000` and log in with `admin`/`admin`.
This container of Grafana has a Prometheus datasource setup using port 9090.  If you change the Prometheus port, you need to add a new data source or update the existing data source. 
You can do this by navigating to `http://<ip>:3000/datasources`

##### Useful Dashboards
We also provide a set of useful Grafana dashboards which would be useful for monitoring the eoracle data validator service. You can find them [here](data-validator/dashboards).
Once you have Grafana set up, feel free to import the dashboards.

### Node exporter
eoracle data validator emits eoracle specific metrics but, it's also important to keep track of the node's health. For this, we will use [Node Exporter](https://prometheus.io/docs/guides/node-exporter/) which is a Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors.
By default, it is installed and started when you start the entire monitoring stack. If you want to modify the stack, you can install the binary or use docker to [run](https://hub.docker.com/r/prom/node-exporter).

In Grafana dashboards screen, import the [node-exporter](dashboards/node-exporter.json) to see host metrics.
