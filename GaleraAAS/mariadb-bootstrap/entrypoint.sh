


exec docker-entrypoint.sh mysqld --wsrep-new-cluster

# create entry point and script this:
#if mysql folder doesn't exists:
#  rm -r /var/lib/mysql/*
#  mysql_install_db --user=mysql
#chown -R mysql:mysql /var/lib/mysql
#chown -R mysql:mysql /var/log/mysql
#chown mysql:mysql /etc/mysql/my.cnf
#GRANT SELECT, RELOAD on *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'viDrrUBGw4Iu9hcY'; 
#GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost' IDENTIFIED BY 's3cr3t';