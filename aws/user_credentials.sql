## ADMIN 
CREATE USER 'admin'@'%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';

## DEV 
#CREATE USER 'dev'@'%' IDENTIFIED BY '';
#GRANT SELECT,DELETE,UPDATE,INSERT,CREATE ON *.* TO 'dev'@'10.0.%';
#GRANT CREATE,DROP ON `user\_%`.* TO 'dev'@'10.0.%';

## APP_PHP 
#CREATE USER 'app_php'@'%' IDENTIFIED BY '';
#GRANT SELECT,DELETE,UPDATE,INSERT,CREATE  ON *.* TO 'app_php'@'10.0.%';

## APP_JAVA 
#CREATE USER 'app_java'@'%' IDENTIFIED BY '';
#GRANT SELECT,DELETE,UPDATE,INSERT,CREATE  ON *.* TO 'app_java'@'10.0.%';

## READ ONLY 
CREATE USER 'ro'@'%' IDENTIFIED BY '';
GRANT SELECT ON *.* TO 'ro'@'%';

## CRON 
#CREATE USER 'cron'@'10.0.%' IDENTIFIED BY '';
#GRANT SELECT,DELETE,UPDATE,INSERT,CREATE,DROP ON *.* TO 'cron'@'10.0.%';

## PHPMYADMIN_RO
#CREATE USER 'phpmyadmin_ro'@'10.0.%' IDENTIFIED BY '';
#GRANT SELECT ON *.* TO 'phpmyadmin_ro'@'10.0.%';

## PHPMYADMIN
#CREATE USER 'phpmyadmin'@'10.0.%' IDENTIFIED BY '';
#GRANT SELECT,DELETE,UPDATE,INSERT,CREATE,DROP ON *.* TO 'phpmyadmin'@'10.0.%';