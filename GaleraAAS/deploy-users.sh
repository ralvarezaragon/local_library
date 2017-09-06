#!/bin/bash
docker exec products-test-db.1 mysql -e "GRANT RELOAD on *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'viDrrUBGw4Iu9hcY'"
docker exec products-test-db.1 mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'200.0.%' WITH GRANT OPTION IDENTIFIED BY 'letmeinbro'"

CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 's3cr3t';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';
CREATE USER 'sstuser'@'%' IDENTIFIED BY 's3cr3t';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'%';
FLUSH PRIVILEGES;