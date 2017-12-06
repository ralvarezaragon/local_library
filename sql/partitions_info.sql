SELECT PARTITION_ORDINAL_POSITION, TABLE_ROWS, PARTITION_METHOD
FROM information_schema.PARTITIONS 
WHERE TABLE_SCHEMA = 'ads_pixel' AND TABLE_NAME = 'pixel_registry';

-- ALTER TABLE ads_pixel.pixel_registry TRUNCATE PARTITION p9;