## Setup monitoring using docker
If you want to set up monitoring using docker, you can use the following commands:

In the folder

* Make sure your prometheus config [file](./prometheus.yml) is updated with the metrics port (`PROMETHEUS_PORT`) of the eigenda node.

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
