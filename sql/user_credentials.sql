##  NOBODY
CREATE USER 'nobody'@'10.0.%';
GRANT ALL PRIVILEGES ON *.* TO 'nobody'@'10.0.%' WITH GRANT OPTION;
## ROOT
CREATE USER 'root'@'10.0.%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.0.%' WITH GRANT OPTION;

## ADMIN
CREATE USER 'admin'@'10.0.%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'10.0.%' WITH GRANT OPTION;

## DEV
CREATE USER 'dev'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE ON *.* TO 'dev'@'10.0.%';

## APP_PHP
CREATE USER 'app_php'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE ON *.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_reports.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_live.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_stacks.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_queue.* TO 'app_php'@'10.0.%';

## APP_PYTHON
CREATE USER 'app_python'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT,DELETE,UPDATE,INSERT ON *.* TO 'app_python'@'10.0.%';

## APP_JAVA
CREATE USER 'app_java'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE ON *.* TO 'app_java'@'10.0.%';

## PHPMYADMIN_RO
CREATE USER 'phpmyadmin_ro'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT ON *.* TO 'phpmyadmin_ro'@'10.0.%';

## PHPMYADMIN
CREATE USER 'phpmyadmin'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE,DROP ON *.* TO 'phpmyadmin'@'10.0.%';
GRANT EXECUTE ON PROCEDURE admin_resources.sp_rename_table TO 'phpmyadmin'@'10.0.%';
GRANT EXECUTE ON PROCEDURE admin_resources.sp_clone_table TO 'phpmyadmin'@'10.0.%';
GRANT EXECUTE ON PROCEDURE admin_resources.sp_query_running TO 'phpmyadmin'@'10.0.%';

## RO
CREATE USER 'ro'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT ON *.* TO 'ro'@'10.0.%';

## CRON
CREATE USER 'cron'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT,DELETE,UPDATE,INSERT ON *.* TO 'cron'@'10.0.%';
GRANT EXECUTE ON PROCEDURE admin_resources.sp_cleanup_month_partition TO 'cron'@'10.0.%';

## CRON_ADMIN
CREATE USER 'cron_admin'@'10.0.%' IDENTIFIED BY '';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE,DROP,ALTER ON *.* TO 'cron_admin'@'10.0.%';

## BKP
CREATE USER 'sstuser'@'localhost';
CREATE USER 'sstuser'@'10.0.%';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'10.0.%';
DROP USER 'sstuser'@'localhost';
DROP USER 'sstuser'@'10.0.%';

## CLUSTERCHECK
CREATE USER 'clustercheckuser'@'10.0.%';
GRANT PROCESS ON *.* TO 'clustercheckuser'@'10.0.%' IDENTIFIED BY '';
GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY '';

## MONITORING
CREATE USER 'collectd'@'10.0.%' IDENTIFIED BY '';
GRANT USAGE ON *.* TO 'collectd'@'10.0.%';
GRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'collectd'@'10.0.%';


## MONITORING
CREATE USER 'collectd'@'localhost' IDENTIFIED BY '';
GRANT USAGE ON *.* TO 'collectd'@'localhost';
GRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'collectd'@'localhost';


## TUNNEL USER
CREATE USER 'tunnel'@'%' IDENTIFIED BY '';
GRANT SELECT ON *.* TO 'tunnel'@'%';
################
# SYS ACCOUNTS #
################
clustercheckuser
debian-sys-maint (fix password)
percona-agent
