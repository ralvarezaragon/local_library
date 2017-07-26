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
#### Generate pem certificates for url exposure for portainer
```
# CA cert
openssl genrsa -aes256 -out frank4-ca-key.pem 4096 
openssl req -new -x509 -days 365 -key frank4-ca-key.pem -sha256 -out frank4-ca.pem
# SERVER cert
openssl genrsa -out frank4-server-key.pem 4096
openssl req -subj "/CN=frank4.basebone.com" -sha256 -new -key frank4-server-key.pem -out frank4-server.csr
echo subjectAltName = DNS:frank4.basebone.com,IP:10.0.3.24,IP:127.0.0.1,IP:10.0.1.102 > extfile.cnf
openssl x509 -req -days 365 -sha256 -in frank4-server.csr -CA frank4-ca.pem -CAkey frank4-ca-key.pem -CAcreateserial -out frank4-server-cert.pem -extfile extfile.cnf
# CLIENT cert
openssl genrsa -out frank4-key.pem 4096
openssl req -subj '/CN=client' -new -key frank4-key.pem -out frank4-client.csr
echo extendedKeyUsage = clientAuth > client-extfile.cnf
openssl x509 -req -days 365 -sha25:x6 -in frank4-client.csr -CA frank4-ca.pem -CAkey frank4-ca-key.pem -CAcreateserial -out frank4-cert.pem -extfile client-extfile.cnf

rm -v client.csr server.csr extfile.cnf client-extfile.cnf
chmod -v 0400 ca-key.pem server-key.pem
chmod -v 0444 ca.pem server-cert.pem cert.pem key.pem
```
#### Enable docker host to listen in 2376 port
The docker daemon needs to be modified to achieve this
```
cp /lib/systemd/system/docker.service /etc/systemd/system/
vim /etc/systemd/system/docker.service
```
- Modify the line for __ExecStart__ ``ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376``
- Create a daemon.json file ``vim /etc/docker/daemon.json``
```
{
  "debug": true,
  "tls": true,
  "tlscacert": "/var/docker/frank4-ca.pem",
  "tlscert": "/var/docker/frank4-server-cert.pem",
  "tlskey": "/var/docker/frank4-server-key.pem"
}

```
- Reload and restart dockerd daemon
```
systemctl daemon-reload
service docker reload
```
#### Create the swarm cluster
First of all we have to declare the swarm cluster and this node will be the manager exposing the internal network interface (10.0.3.24)
```
docker swarm init --advertise-addr enp10s0
```
Now every node that needs to join the cluster will run as follow:
```
docker swarm join --token SWMTKN-1-34py9trc0j4yuvexqdkjfl9mmehcz2eqgcr1uyi9olq4fgg2xh-eo8ybtql85tbqsa4e5p2ks913 10.0.3.24:2377
```
#### Create the network
In order to connect a bunch of machines and orchestrate with swarm we use overlap driver
```
docker network create -d overlay --subnet=100.0.0.0/16 --gateway=100.0.0.1 --ip-range=100.0.0.0/24 bbnet-prod
```