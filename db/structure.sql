CREATE TABLE `listings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `twitter` varchar(255) DEFAULT NULL,
  `address` text,
  `employees` varchar(255) DEFAULT NULL,
  `founders` text,
  `active` tinyint(1) DEFAULT NULL,
  `hiring` tinyint(1) DEFAULT NULL,
  `hiringurl` varchar(255) DEFAULT NULL,
  `listername` varchar(255) DEFAULT NULL,
  `listeremail` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_listings_on_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `listing` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20130419205110');

INSERT INTO schema_migrations (version) VALUES ('20130419210416');

INSERT INTO schema_migrations (version) VALUES ('20130420000630');

INSERT INTO schema_migrations (version) VALUES ('20130420222536');

INSERT INTO schema_migrations (version) VALUES ('20130421190609');