#!/bin/bash
docker exec products-test-db.1 mysql -e "GRANT RELOAD on *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'viDrrUBGw4Iu9hcY'"
docker exec products-test-db.1 mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'200.0.%' WITH GRANT OPTION IDENTIFIED BY 'letmeinbro'"
