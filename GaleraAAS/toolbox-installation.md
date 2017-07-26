#### Install Docker 17 with Swarm
``` 
apt-get remove docker docker-engine
apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu    $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce
update-rc.d docker disable
```
#### Install portainer container
```
docker pull portainer/portainer
docker run --name portainer -h portainer -v "/var/run/docker.sock:/var/run/docker.sock" -d -p 9000:9000 portainer/portainer
```
 - Portainer is now accesible via toolbox.basebone.com:9000
 - Setup the admin password. By default let's use *__letmeinbro__*
#### Install local repository (registry)
```
docker run -d -p 5000:5000 --restart=always --name bbregistry registry:2
```
From now onwards every image to upload to registry:
```
docker tag [image_name] toolbox.basebone.com:5000/[image_name]
docker push toolbox.basebone.com:5000/[image_name]
```
#### Install prometheus
- Create the folder structure for this conainter
```
mkdir monitoring-test-db
mkdir monitoring-test-db/data && mkdir monitoring-test-db/config && mkdir monitoring-test-db/log
```
- Create the config file for prometheus ``vim /opt/monitoring-test-db/config/prometheus.yml`` and paste this code

```

# A scrape configuration scraping a Node Exporter and the Prometheus server
# itself.
scrape_configs:
  # Scrape Prometheus itself every 5 seconds.
  - job_name: 'prometheus'
    scrape_interval: 5s
    target_groups:
      - targets: ['localhost:9090']

  # Scrape the Node Exporter every 5 seconds.
  - job_name: 'node'
    scrape_interval: 5s
    target_groups:
      - targets: ['your_server_ip:9100']
```
```
docker run -d -p 9090:9090 \
--name monitoring-test-db \
--hostname monitoring-test-db \
--cpus="4" \
--memory="4000m" \
-v /opt/monitoring-test-db/config/prometheus.yml:/etc/prometheus/prometheus.yml \
-v /opt/monitoring-test-db/data:/prometheus \
prom/prometheus \
-config.file=/etc/prometheus/prometheus.yml \
-storage.local.path=/prometheus \
-storage.local.memory-chunks=10000
```
