SELECT TABLE_SCHEMA, TABLE_NAME, partition_name, PARTITION_ORDINAL_POSITION, TABLE_ROWS, PARTITION_METHOD
FROM information_schema.PARTITIONS
WHERE TABLE_SCHEMA = 'ads_log' AND TABLE_NAME = 'ads_tracking';

-- ALTER TABLE ads_pixel.pixel_registry TRUNCATE PARTITION p9;


SELECT TABLE_SCHEMA, TABLE_NAME
FROM information_schema.PARTITIONS
where partition_name is not null
group by TABLE_SCHEMA, TABLE_NAME


admin@10.0.8.51 [(none)]> SELECT TABLE_SCHEMA, TABLE_NAME
    -> FROM information_schema.PARTITIONS
    -> where partition_name is not null
    -> group by TABLE_SCHEMA, TABLE_NAME;
+----------------------------+----------------------------+
| TABLE_SCHEMA               | TABLE_NAME                 |
+----------------------------+----------------------------+
| esme_billing               | threshold_reminder         |
| esme_limits                | subscription_billing_cache |
| esme_messaging             | customer_activity          |
| esme_oneoff                | mpesa_ke_purchases         |
| esme_reminders             | latest_reminder            |
| esme_reminders             | reminder_completed         |
| esme_subscriptions_history | stop_confirmation          |
+----------------------------+----------------------------+
