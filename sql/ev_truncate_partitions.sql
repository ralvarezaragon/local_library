-- CREATE ONLY IN admin_resources;
DELIMITER $$
CREATE EVENT ev_partition_test
ON SCHEDULE EVERY '1' MONTH
STARTS '2017-11-02 15:00:00'
DO
BEGIN
	call test.cleanup_month_partition('test', 'partition_test', 3);
END$$

DELIMITER ;