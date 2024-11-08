## Setup monitoring using docker
If you want to set up monitoring using docker, you can use the following commands:

In the `monitoring` folder

Make sure your [prometheus](./prometheus.yml) and [VM-agent](./vmagent.yml) config files is updated with the following
  * the metrics port (`PROMETHEUS_PORT`) of the eOracle data validator

You have the option to submit your data validator metrics to the eOracle monitoring platform. If you want to do that, you will need to update the VM-agent config [file](./vmagent.yml) with the following
  * the metrics port (`PROMETHEUS_PORT`) of the eOracle data validator
  * the operator address (`OPERATOR_ADDRESS`)
  * the eochain (`eochain`) either mainnet or testnet

If you don't want to submit your metrics to the eOracle monitoring platform, you can remove the `vmagent` service from the `docker-compose.yml` file

Once correct config is set up, run the following command to start the monitoring stack
```bash
docker compose up -d
```

Since Eoracle data fetcher is running in a different docker network we will need to have prometheus in the same network. To do that, run the following command:
```bash
docker network connect eoracle-data-fetcher prometheus
```
This will make sure `prometheus` can scrape the metrics from `Eoracle data fetcher` service.


#### Useful Dashboards
We also provide a set of useful Grafana dashboards which would be useful for monitoring the Eoracle data fertcher service. You can find them [here](../dashboards).
Once you have Grafana setup, feel free to import the dashboards.
