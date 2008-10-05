CREATE TABLE `accounts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `username` varchar(25) NOT NULL default '',
  `contact_name` varchar(50) NOT NULL default '',
  `email` varchar(50) NOT NULL default '',
  `password` varchar(18) NOT NULL default '',
  `note` text,
  `business_name` varchar(200) NOT NULL default '',
  `business_address` varchar(200) NOT NULL default '',
  `phone` varchar(25) NOT NULL default '',
  `cellphone` varchar(25) NOT NULL default '',
  `country` varchar(25) NOT NULL default 'New Zealand',
  `shipping_address` varchar(200) default NULL,
  `suspended` int(1) unsigned NOT NULL default '0',
  `price_level_id` int(10) unsigned NOT NULL default '0',
  `time_created` datetime default NULL,
  `fax_number` varchar(25) default NULL,
  `special_offers` int(1) NOT NULL default '0',
  `agree_terms` int(1) NOT NULL default '0',
  `account_type` int(1) NOT NULL default '0',
  `postcode` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `administrators` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(18) NOT NULL default '',
  `password` varchar(18) NOT NULL default '',
  `level` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `categories` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL default '',
  `p_id` int(10) unsigned NOT NULL default '0',
  `level_order` int(1) default '0',
  `label` varchar(250) NOT NULL default '',
  `level_num` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

CREATE TABLE `charities` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(200) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `freightoptions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default 'enter an option name',
  `price` float NOT NULL default '0',
  `note` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `imageobjects` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `name` varchar(150) default NULL,
  `image` varchar(200) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE `orderitems` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `order_id` int(10) unsigned NOT NULL default '0',
  `product_id` int(10) unsigned NOT NULL default '0',
  `price_in_order` float NOT NULL default '0',
  `quantity` int(10) unsigned NOT NULL default '0',
  `quantity_shipped` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `time_created` datetime default NULL,
  `customer_id` int(10) unsigned NOT NULL default '0',
  `island` varchar(6) NOT NULL default '',
  `is_rural` varchar(6) NOT NULL default '',
  `shipping_address` text NOT NULL,
  `suggested_freight_cost` float NOT NULL default '0',
  `suggested_freight_options` text NOT NULL,
  `last_time_of_sentmail` datetime default NULL,
  `note` text NOT NULL,
  `status` varchar(45) NOT NULL default '',
  `date_shipped` varchar(25) default 'dd/mm/yyyy',
  `track_numbers` varchar(255) default 'n/a',
  `arrival_date` varchar(25) default 'dd/mm/yyyy',
  `postcode` varchar(8) NOT NULL default '',
  `donee` varchar(200) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE TABLE `pages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `value` longtext NOT NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE TABLE `pricelevels` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(100) NOT NULL default 'A price level',
  `discount_percentage` int(10) unsigned NOT NULL default '0',
  `note` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `pricelevels_matrix` (
  `id` int(11) NOT NULL auto_increment,
  `pricelevel_id` int(11) NOT NULL default '0',
  `product_id` int(11) NOT NULL default '0',
  `price` float NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;

CREATE TABLE `product_condition_relation` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `pid` int(10) unsigned default NULL,
  `cid` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `product_warranty_relation` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `pid` int(10) unsigned default NULL,
  `wid` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `productconditions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `condition` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `productimages` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `image` varchar(200) default NULL,
  `product_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;

CREATE TABLE `products` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `time_created` datetime default NULL,
  `price` float NOT NULL default '0',
  `details` text NOT NULL,
  `delivery` int(10) unsigned NOT NULL default '0',
  `stock_level` int(10) unsigned NOT NULL default '1',
  `warranty_id` int(10) unsigned default '0',
  `condition_id` int(10) unsigned default '0',
  `title` varchar(200) NOT NULL default '',
  `category_id` int(10) unsigned NOT NULL default '1',
  `category_id_fix_1` int(11) default '-1',
  `category_id_fix_2` int(11) default '-1',
  `freightoption_id` int(10) unsigned NOT NULL default '1',
  `labels` text NOT NULL,
  `views` int(11) default '0',
  `donation` double default '0',
  PRIMARY KEY  (`id`),
  FULLTEXT KEY `details` (`details`,`title`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

CREATE TABLE `productwarranties` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `warranty` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL default '',
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2117 DEFAULT CHARSET=latin1;

CREATE TABLE `shops` (
  `id` int(11) NOT NULL auto_increment,
  `shop_name` varchar(200) NOT NULL default '',
  `header_message` text NOT NULL,
  `version` varchar(10) NOT NULL default '',
  `allow_donation` int(11) NOT NULL default '0',
  `def_template_name` varchar(50) default 'default',
  `tax_name` varchar(25) default NULL,
  `tax_rate` double NOT NULL default '0',
  `is_tax_incl_when_adding_new_product` int(11) NOT NULL default '1',
  `install_dir_name` varchar(200) default NULL,
  `admin_email` varchar(200) default NULL,
  `company_name` varchar(200) default NULL,
  `b_addr` text,
  `b_phone` varchar(200) default NULL,
  `b_mobile` varchar(200) default NULL,
  `b_bank_acct` varchar(200) default NULL,
  `b_website` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `tabs` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default 'None',
  `visible` int(11) NOT NULL default '1',
  `position` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (2)