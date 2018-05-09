CREATE TABLE `subscriptions_dev` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
--  `msisdn` bigint(20) NOT NULL, 
  `real_msisdn` bigint(20) NOT NULL DEFAULT '0',
--  `company` int(11) NOT NULL DEFAULT '0',
--  `product` int(11) NOT NULL DEFAULT '0',
  `login` varchar(20) DEFAULT NULL,
--  `country` int(11) NOT NULL DEFAULT '0',
--  `endpoint` int(11) NOT NULL DEFAULT '0',
--  `network` int(11) NOT NULL DEFAULT '0',
--  `application` int(11) NOT NULL DEFAULT '0',
--  `service` int(11) NOT NULL DEFAULT '0',
  `ported` int(11) NOT NULL DEFAULT '0',
  `signup_stamp` int(11) NOT NULL DEFAULT '0',
  `unsubscription` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
--  `reminder_stamp` int(11) NOT NULL DEFAULT '0',
  `service_reminder_stamp` int(11) NOT NULL DEFAULT '0',
  `renew_stamp` int(11) NOT NULL DEFAULT '0',
  `monthstamp` int(11) NOT NULL DEFAULT '0',
  `daystamp` int(11) NOT NULL DEFAULT '0',
  `keyword` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `mtn` int(11) NOT NULL DEFAULT '0',
  `pin` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `password` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `campaign` int(11) NOT NULL DEFAULT '0',
  `clientid` int(11) NOT NULL DEFAULT '3',
  `text_container_id` int(11) NOT NULL DEFAULT '0',
  `meta_type` int(11) NOT NULL DEFAULT '0',
  `meta_id` int(11) NOT NULL DEFAULT '0',
  `counter` int(11) NOT NULL DEFAULT '1',
  `billed` tinyint(4) NOT NULL DEFAULT '1',
  `tokens` int(11) NOT NULL DEFAULT '0',
  `tokens2` int(11) NOT NULL DEFAULT '0',
  `doubleoptin` tinyint(4) NOT NULL DEFAULT '1',
  `testnumber` enum('yes','no') NOT NULL DEFAULT 'no',
  `billing_attempts` int(11) NOT NULL DEFAULT '0',
  `billing_successes` int(11) NOT NULL DEFAULT '0',
  `last_billing_attempt` int(11) NOT NULL DEFAULT '0',
  `last_billing_success` int(11) NOT NULL DEFAULT '0',
  `messages_per_month` int(11) NOT NULL DEFAULT '0',
  `next_reset` int(11) NOT NULL DEFAULT '0',
  `plan_original` int(11) NOT NULL DEFAULT '0',
  `plan_current` int(11) NOT NULL DEFAULT '0',
  `optin_type` tinyint(4) NOT NULL DEFAULT '0',
  `optin_reference` varchar(50) DEFAULT NULL,
  `optin_info` text,
  `optin_message` text,
  `fake_reminder` int(11) NOT NULL DEFAULT '0',
  `last_hlr` int(11) NOT NULL DEFAULT '0',
  `added_to_db` enum('yes','no') NOT NULL DEFAULT 'no',
  `external_subscription_id` varchar(80) DEFAULT NULL,
  `external_subscription_2` varchar(80) DEFAULT '',
  `external_subscription_3` varchar(80) DEFAULT '',
  `external_subscription_4` varchar(80) DEFAULT '',
  `external_renewal` enum('yes','no') NOT NULL DEFAULT 'no',
  `domain_id` int(11) NOT NULL DEFAULT '0',
  `domain` varchar(50) DEFAULT NULL,
  `publisher` int(11) NOT NULL DEFAULT '0',
  `affiliate` int(11) NOT NULL DEFAULT '0',
  `aggregator_change` enum('yes','no') NOT NULL DEFAULT 'no',
  `bucket` int(11) NOT NULL DEFAULT '0',