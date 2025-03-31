# eoracle Operator Setup
This guide will walk you through the process of registering as an operator to eoracle AVS and running the eoracle software.

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
### ​Prepare Local eoracle data validator files
Clone this [repo](https://github.com/Eoracle/Eoracle-operator-setup) and execute the following commands
```bash
git clone https://github.com/Eoracle/Eoracle-operator-setup.git
cd Eoracle-operator-setup
cp data-validator/.example_env data-validator/.env
```
Copy `Eoracle-operator-setup/data-validator/.example_env` into `Eoracle-operator-setup/data-validator/.env`.  
Edit the `Eoracle-operator-setup/data-validator/.env` and update the values for your setup

[**NOTE**]
If you plan to operate eoracle on Holesky, then copy `.example_env_holeksy` instead of `.example_env`.  
```bash
cp data/validator/.example_env_holeksy data-validaotr/.env`
```

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

### Troubleshooting the register command.
salt already spent - if you get the following error:
```
Failed to create RegisterOperator transaction execution reverted: AVSDirectory.registerOperatorToAVS: salt already spent
```
Please add EO_SALT=<salt_in_hex> field to your .env file and retry runnning register.  

(*) the EO_SALT should be in the following format EO_SALT=0x04 (even length hex number, and could be any number but must be even length)

### Generating an alias ECDSA address 
Operators must declare another ECDSA address to use within the eoracle client. This isolates the Ethereum Eigenlayer operator private key from eoracle operations, protecting access to Ethereum assets.
You can import a private key or generate a new private key. To import , add `--ecdsa-private-key <value>` to the following command.
```bash
./run.sh generate-alias
```

```
❯ ls -la /path/to/keystore.keystore
-rw-r--r--@ 1 <usr>  staff  554 Apr 11 20:18 blsEncryptedWallet.json
-rw-r--r--  1 <usr>  staff  491 Apr 12 00:06 ecdsaAliasedEncryptedWallet.json
-rw-r--r--@ 1 <usr>  staff  491 Apr 11 20:18 ecdsaEncryptedWallet.json
```

### Declare the alias in eoracle chain
After generating the ECDSA alias address to use in eoracle chain, declare it using your Ethereum Eigenlayer identity, verifying the link between the two.
and current

[**NOTE**]
Command below wouldn't work on Holesky and you'll need contact support to register for now.
```bash
./run.sh declare-alias
```

The output should look like
```
succesfully declared an alias in the eochain
docker-entrypoint-oprcli.sh: Starting oprcli declare-alias 
{"level":"info","ts":1712824061.311895,"caller":"logging/zap_logger.go:49","msg":"succesfully declared an alias in the eochain","eochain address":"0x...", "eochain address", "0x...", "tx hash", "0x..."}
```


### Checking the status of Eoracle operator AVS

The following command will print the status of the operator

[**NOTE**]
Command below wouldn't work on Holesky and you'll need contact support to register for now.
```bash
./run.sh print-status
```

The output should look like
```
docker-entrypoint-oprcli.sh: Starting oprcli print-status 
{"level":"info","ts":1712824061.311895,"caller":"logging/zap_logger.go:49","msg":"Operator Status","status":"REGISTERED"}
{"level":"info","ts":1712824061.3466434,"caller":"logging/zap_logger.go:49","msg":"Operator stake update","stake":"<your_stake>","block number":1253026}
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

## Running eoracle AVS data validator

**eoracle operator Activation:** Ensure your account has been activated. In order to check your current status you can run the following (1 is activated, 0 is not). Stay tuned for activation windows on social media , for technical issues please contact the eoracle team [here](https://discord.gg/eoracle) on the operators-technical-help channel 
```bash
cast call 0x05a6f762f64Ac2ccE0588677317a0Ed8af9d0c16 "isValidatorActive(address validator)" <your alias address> -r https://rpc.eoracle.network | cast 2d
```



Note: Access to our client source code is currently restricted, however, interested parties may contact support@eoracle.io to review the client for security reasons. 


### Run using docker
Run the docker
```bash
cd data-validator
docker compose up -d
```

The command will start the data validator container. If you execute `docker ps` you should see an output indicating the `eoracle-data-validator` container has the " Up " status with ports assigned.
You may view the container logs using
```bash
docker logs -f eoracle-data-validator
```

#### Data Validator V1 logs

The following example log messages confirm that your eOracle data validator software is up and running. Please ensure that your alias is declared and activated.

```sh
2024-04-11 22:32:04 <1> 2024-04-11T19:32:04.467Z info:  Validator restarts on events: OnConfigChange
2024-04-11 22:32:04 <1> 2024-04-11T19:32:04.469Z info:  Health endpoints are available through port: 9000
2024-04-11 22:32:04 <1> 2024-04-11T19:32:04.469Z info:  Prometheus metrics are available through port: 9100
2024-04-11 22:32:05 <1> 2024-04-11T19:32:05.041Z info:  sent transaction b4f25b20a25c442dd0cb629395ce4b0859b3110f39b617ba5d4a112c5199a2a0 [nonce:0]  to block 256 ---<some_data> ---duration: 0.083 ---block received at 2024-04-11T19:32:04.958Z
2024-04-11 22:32:06 <1> 2024-04-11T19:32:06.130Z info:  sent transaction 191351c865a81379bace9c94d19fd605fddac04ba738d67bfd42d6618f97a322 [nonce:1]  to block 257 ---<some_data> ---duration: 0.03 ---block received at 2024-04-11T19:32:06.100Z
2024-04-11 22:32:07 <1> 2024-04-11T19:32:07.257Z info:  sent transaction 118e70a76fa0e65bcc7664b8b1feb6d6e820c0fc38d28968a5175e8b66b088ca [nonce:2]  to block 258 ---<some_data> ---duration: 0.022 ---block received at 2024-04-11T19:32:07.232Z
2024-04-11 22:32:08 <1> 2024-04-11T19:32:08.334Z info:  sent transaction cd825772a985ba01744712ffffea4376d7ab950e4f1cbf502f5c1189b79374a9 [nonce:3]  to block 259 ---<some_data> ---duration: 0.018 ---block received at 2024-04-11T19:32:08.316Z
2024-04-11 22:32:09 <1> 2024-04-11T19:32:09.504Z info:  sent transaction ef1b958dad78ca229c9efeff281e7691956634e6aa588fc03a5554b5800865ad [nonce:4]  to block 260 ---<some_data> ---duration: 0.016 ---block received at 2024-04-11T19:32:09.488Z
2024-04-11 22:32:10 <1> 2024-04-11T19:32:10.671Z info:  sent transaction 322f19fe10759660a8328bd8be6974ef9be5fac861e6069548380d277998091b [nonce:5]  to block 261 ---<some_data> ---duration: 0.021 ---block received at 2024-04-11T19:32:10.650Z
2024-04-11 22:32:11 <1> 2024-04-11T19:32:11.778Z info:  sent transaction f3e3a27fa1adcd3a89336b14e8342e60b943e9376f11c416128689d1e06d17dd [nonce:6]  to block 262 ---<some_data> ---duration: 0.016 ---block received at 2024-04-11T19:32:11.762Z
2024-04-11 22:32:12 <1> 2024-04-11T19:32:12.958Z info:  sent transaction f1310e2e16f873a7f121f0359e48a9d0b5de7cb887df6174081e8d2977d231c2 [nonce:7]  to block 263 ---<some_data> ---duration: 0.018 ---block received at 2024-04-11T19:32:12.940Z
2024-04-11 22:32:14 <1> 2024-04-11T19:32:14.135Z info:  sent transaction c3fed5490435682dfee86b15725ab1514d9f5802e8c7fc5e0f39a43c71bed4fc [nonce:8]  to block 264 ---<some_data> ---duration: 0.014 ---block received at 2024-04-11T19:32:14.121Z
2024-04-11 22:32:15 <1> 2024-04-11T19:32:15.260Z info:  sent transaction fa0017193eaef5f8b465ccbcb86fb3789d567ed34c688efcc5abc80915ccf0cd [nonce:9]  to block 265 ---<some_data> ---duration: 0.029 ---block received at 2024-04-11T19:32:15.231Z
2024-04-11 22:32:16 <1> 2024-04-11T19:32:16.399Z info:  sent transaction 5259a10f8dd43acc8e3f66e97b8489299d20caad9f0da0344ed9dea413f3bcf6 [nonce:10]  to block 266 ---<some_data> ---duration: 0.021 ---block received at 2024-04-11T19:32:16.378Z
2024-04-11 22:32:17 <1> 2024-04-11T19:32:17.505Z info:  sent transaction f0bfeb6223f3bd09ef8f251bb05b3c5c81b1c02ea555c5a2846077e11c145e31 [nonce:11]  to block 267 ---<some_data> ---duration: 0.013 ---block received at 2024-04-11T19:32:17.492Z
2024-04-11 22:32:18 <1> 2024-04-11T19:32:18.622Z info:
```

#### Data Validator V2 logs

The following example log messages confirm that your eOracle data validator software is up and running. Please ensure that your alias is declared and activated.

```sh
{"lvl":"INF","component":"validator","healthEndpointsPort":9000,"prometheusPort":9100,"dataPort":9200,"t":"2025-03-28T17:43:24.921","msg":"HTTP servers started"}
{"lvl":"INF","component":"validator","configProvider":"0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9","registryContractAddress":"0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512","ovsAddresses":"HashSet\n0x5FC8d32690cc91D4c39d9d3abcBD16989F875707","mainAddress":"0x70997970C51812dc3A010C7d01b50e0d17dc79C8","keyStorePath":"/Users/michael-eoracle/Projects/core/go-datavalidator/.keystore","t":"2025-03-28T17:43:25.663","msg":"configProvider started"}
{"lvl":"INF","component":"validator","t":"2025-03-28T17:43:25.741","msg":"configProvider is running"}
{"lvl":"INF","component":"validator","t":"2025-03-28T17:43:25.741","msg":"calling onSourcesChange"}
{"lvl":"INF","component":"validator","t":"2025-03-28T17:43:25.741","msg":"initFeedsReporting started"}
{"lvl":"INF","component":"validator","time":"2025-03-28T19:43:25.742","t":"2025-03-28T17:43:25.742","msg":"feeds reporting initializing..."}
{"lvl":"INF","component":"validator","source":"coinbase","sourceID":"4","wsMsg":"{\"type\":\"subscribe\",\"product_ids\":[\"USDT-USD\",\"ARB-USD\",\"AVAX-USD\",\"BTC-USD\",\"SWELL-USD\",\"SOL-USD\",\"FIL-USD\",\"DOGE-USD\",\"MATIC-USD\",\"DAI-USD\",\"ETH-USD\",\"DOT-USD\",\"SHIB-USD\",\"LINK-USD\",\"UNI-USD\",\"XRP-USD\",\"LTC-USD\",\"ADA-USD\",\"OP-USD\"],\"channels\":[\"ticker\",\"heartbeat\"]}","t":"2025-03-28T17:43:26.310","msg":"subscribe message"}
{"lvl":"INF","component":"validator","source":"bybit","sourceID":"17","symbols":["OPUSDT","LTCUSDT","ZRCUSDT","AVAXUSDT","ARBUSDT","LINKUSDT","DOTUSDT","MANTAUSDT","TRXUSDT","SWELLUSDT"],"t":"2025-03-28T17:43:26.554","msg":"preparing subscription request for chunk"}
{"lvl":"INF","component":"validator","source":"bybit","sourceID":"17","symbols":["SOLUSDT","TONUSDT","FTMUSDT","DAIUSDT","TRUMPUSDT","XRPUSDT","TAIKOUSDT","ADAUSDT","PLUMEUSDT","DOGEUSDT"],"t":"2025-03-28T17:43:26.554","msg":"preparing subscription request for chunk"}
{"lvl":"INF","component":"validator","source":"bybit","sourceID":"17","symbols":["ETHUSDT","SUSDT","USDCUSDT","BBUSDT","FILUSDT","BTCUSDT","BNBUSDT"],"t":"2025-03-28T17:43:26.554","msg":"preparing subscription request for chunk"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:ADA_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:XRP_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:TON_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:DOGE_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:BB_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:BNB_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:SOL_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:LTC_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:TRX_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:MODE_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:BTC_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:TAIKO_USDT","t":"2025-03-28T17:43:26.654","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:SHIB_USDT","t":"2025-03-28T17:43:26.655","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:DOT_USDT","t":"2025-03-28T17:43:26.655","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bitmart","sourceID":"18","topic":"spot/ticker:ETH_USDT","t":"2025-03-28T17:43:26.655","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bybit","sourceID":"17","conn_id":"f87ff096-c6ef-4594-817a-c15c0cc1af4a","t":"2025-03-28T17:43:26.735","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bybit","sourceID":"17","conn_id":"f87ff096-c6ef-4594-817a-c15c0cc1af4a","t":"2025-03-28T17:43:26.737","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"bybit","sourceID":"17","conn_id":"f87ff096-c6ef-4594-817a-c15c0cc1af4a","t":"2025-03-28T17:43:26.737","msg":"subscription successful"}
{"lvl":"INF","component":"validator","source":"gateio","sourceID":"19","symbols":["\"USDC_USDT\"","\"MANTA_USDT\"","\"ZRC_USDT\"","\"TRUMP_USDT\"","\"SHIB_USDT\"","\"S_USDT\"","\"ETH_USDT\"","\"LTC_USDT\"","\"LINK_USDT\"","\"TRX_USDT\"","\"SOL_USDT\"","\"DOT_USDT\"","\"ARB_USDT\"","\"BTC_USDT\"","\"TON_USDT\"","\"PLUME_USDT\"","\"BNB_USDT\"","\"ADA_USDT\"","\"DOGE_USDT\"","\"XRP_USDT\"","\"DAI_USDT\"","\"SWELL_USDT\"","\"OP_USDT\"","\"SOV_USDT\"","\"FIL_USDT\""],"t":"2025-03-28T17:43:27.234","msg":"subscribing to symbols"}
{"lvl":"INF","component":"validator","connection":"localnonce","txHash":"0x91162245ec4d22d206434ea94956467272460afb50b1d6460d2d417fc104f8d2","blockNumber":"6778","blockHash":"0x1f691748aabcb8797928d1a6d4f140d3742ad0fe9b7e057fe35a542bae4080b3","gasUsed":5612449,"effectiveGasPrice":"50000007","accepted":true,"sendingDuration":2.186042,"waitingDuration":3002.025833,"t":"2025-03-28T17:43:30.904","msg":"received receipt for transaction"}
{"lvl":"INF","reporter":"eochain","blockNumber":"6777","aggregatorAddress":"0x5FC8d32690cc91D4c39d9d3abcBD16989F875707","aggregatorReportsCount":1,"blockAppeared":"2025-03-28T17:43:27.895","txHash":"0x91162245ec4d22d206434ea94956467272460afb50b1d6460d2d417fc104f8d2","t":"2025-03-28T17:43:30.904","msg":"quotes reported"}
{"lvl":"INF","component":"validator","connection":"localnonce","txHash":"0x146940e6a43805d781ba46ad3323ed037ead7c11486335a6dcbb62550c4e5d0f","blockNumber":"6779","blockHash":"0xbb4b7df9a83f8042d8948842eb6d46309f002087dceba48284d72625cb19c5ed","gasUsed":5698033,"effectiveGasPrice":"50000007","accepted":true,"sendingDuration":2.798292,"waitingDuration":2995.488624,"t":"2025-03-28T17:43:33.904","msg":"received receipt for transaction"}
{"lvl":"INF","reporter":"eochain","blockNumber":"6778","aggregatorAddress":"0x5FC8d32690cc91D4c39d9d3abcBD16989F875707","aggregatorReportsCount":1,"blockAppeared":"2025-03-28T17:43:30.903","txHash":"0x146940e6a43805d781ba46ad3323ed037ead7c11486335a6dcbb62550c4e5d0f","t":"2025-03-28T17:43:33.905","msg":"quotes reported"}
{"lvl":"INF","component":"validator","connection":"localnonce","txHash":"0x3540297cd201b02891f9a4faeed59e0b4d3e5e9c91af774ad644f434461d47bb","blockNumber":"6780","blockHash":"0x75b72660a0aae20c2d1afbc01a28e792fbefa3fcaac3a43f11b9a69b123a4d61","gasUsed":5695245,"effectiveGasPrice":"50000007","accepted":true,"sendingDuration":2.5475,"waitingDuration":2995.831167,"t":"2025-03-28T17:43:36.906","msg":"received receipt for transaction"}
{"lvl":"INF","reporter":"eochain","blockNumber":"6779","aggregatorAddress":"0x5FC8d32690cc91D4c39d9d3abcBD16989F875707","aggregatorReportsCount":1,"blockAppeared":"2025-03-28T17:43:33.904","txHash":"0x3540297cd201b02891f9a4faeed59e0b4d3e5e9c91af774ad644f434461d47bb","t":"2025-03-28T17:43:36.906","msg":"quotes reported"}
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
3. Merge .env changes.
Go over `.example_env` or `.example_env_holesky` and merge new fields that do not appear in your local `.env` file.
   - The structure of .example_env_holesky  has been changed to support data validator V2

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
