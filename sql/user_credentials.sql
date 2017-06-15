## ADMIN 
CREATE USER 'admin'@'10.0.%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'10.0.%' WITH GRANT OPTION;

## DEV 
CREATE USER 'dev'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE ON *.* TO 'dev'@'10.0.%';

## APP_PHP 
CREATE USER 'app_php'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE ON *.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_reports.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_live.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_stacks.* TO 'app_php'@'10.0.%';
GRANT DROP ON esme_queue.* TO 'app_php'@'10.0.%';

## APP_JAVA 
CREATE USER 'app_java'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE ON *.* TO 'app_java'@'10.0.%';

## READ ONLY 
CREATE USER 'ro'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT ON *.* TO 'ro'@'10.0.%';

## PHPMYADMIN_RO
CREATE USER 'phpmyadmin_ro'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT ON *.* TO 'phpmyadmin_ro'@'10.0.%';

## PHPMYADMIN
CREATE USER 'phpmyadmin'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE,DROP ON *.* TO 'phpmyadmin'@'10.0.%';
GRANT EXECUTE ON PROCEDURE admin_resources.sp_rename_table TO 'phpmyadmin'@'10.0.%';

## CRON 
CREATE USER 'cron'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT,DELETE,UPDATE,INSERT ON *.* TO 'cron'@'10.0.%';

## CRON_ADMIN
CREATE USER 'cron_admin'@'10.0.%' IDENTIFIED BY 'password';
GRANT SELECT,DELETE,UPDATE,INSERT,CREATE,DROP,ALTER ON *.* TO 'cron_admin'@'10.0.%';

################
# SYS ACCOUNTS #
################
clustercheckuser
debian-sys-maint (fix password)
percona-agent=