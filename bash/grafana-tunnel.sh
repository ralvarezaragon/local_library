sudo ssh -nNT -i ~/.ssh/systemsKey.pem  ubuntu@52.18.76.204 -L 443:localhost:443 -L 9090:localhost:9090 -L 9103:localhost:9103 -L 9115:localhost:9115
