CREATE TABLE `billing` (
  `billing_id` int(11) AUTO_INCREMENT,  
  `subscription_id` bigint(20) NOT NULL,
  `billing_attempts` int(11) NOT NULL DEFAULT '0',
  `billing_successes` int(11) NOT NULL DEFAULT '0',
  `last_billing_attempt` int(11) NOT NULL DEFAULT '0',
  `last_billing_success` int(11) NOT NULL DEFAULT '0',
  `messages_per_month` int(11) NOT NULL DEFAULT '0',
  `bucket` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY(`billing_id`)  
) ENGINE=InnoDB AUTO_INCREMENT=68931965 DEFAULT CHARSET=latin1;




