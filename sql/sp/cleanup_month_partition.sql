-- CREATE ONLY IN admin_resources;
-- call admin_resources.sp_cleanup_month_partition('test', 'partition_test', 3);
-- This sp will truncate every partition older than 3, for instances
-- Use it only for month partitions p1...p12!!!
CREATE DEFINER=`admin`@`10.0.%` PROCEDURE `sp_cleanup_month_partition`(
 dbname varchar(255),
 tname varchar(255),
 to_truncate int(1)
)
BEGIN
	SET @i := 1;
    SET @to_truncate := to_truncate;
	SET @dbname := dbname;
    SET @tname := tname;
	SET @month_to_truncate := (SELECT month(DATE_ADD(NOW(), INTERVAL -@to_truncate MONTH)));
	WHILE @i <= @month_to_truncate DO
		SET @query = CONCAT('ALTER TABLE ', @dbname, '.', @tname, ' TRUNCATE PARTITION p', @i);
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		SET @i = @i + 1;
	END WHILE;
END