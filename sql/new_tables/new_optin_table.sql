CREATE TABLE `optin` (
  `optin_id` int(11) AUTO_INCREMENT,  
  `subscription_id` bigint(20) NOT NULL,  
  `doubleoptin` tinyint(4) NOT NULL DEFAULT '1',
  `optin_type` tinyint(4) NOT NULL DEFAULT '0',
  `optin_reference` varchar(50) DEFAULT NULL,
  `optin_info` text,
  `optin_message` text,
  PRIMARY KEY(`optin_id`)  
) ENGINE=InnoDB AUTO_INCREMENT=68931965 DEFAULT CHARSET=latin1;