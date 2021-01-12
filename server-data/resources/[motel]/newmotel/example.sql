CREATE TABLE IF NOT EXISTS `utk_motels_6` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `inventory` longtext NOT NULL DEFAULT '[]',
  `weapons` longtext NOT NULL DEFAULT '[]',
  `clothes` longtext NOT NULL DEAFULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4;

INSERT INTO `utk_motels_expenses` (`motelId`, `debt`, `auto_pay`) VALUES
	(6, 0, 0),

INSERT INTO `utk_motels_6` (`id`, `inventory`, `weapons`, `clothes`) VALUES
	(1, '[]', '[]', '[]', 0),
	(2, '[]', '[]', '[]', 0),
	(3, '[]', '[]', '[]', 0),
	(4, '[]', '[]', '[]', 0),
	(5, '[]', '[]', '[]', 0),
	(6, '[]', '[]', '[]', 0),
	(7, '[]', '[]', '[]', 0),
	(8, '[]', '[]', '[]', 0),
	(9, '[]', '[]', '[]', 0),
	(10, '[]', '[]', '[]', 0),
	(11, '[]', '[]', '[]', 0),
	(12, '[]', '[]', '[]', 0),
	(13, '[]', '[]', '[]', 0),
	(14, '[]', '[]', '[]', 0),
	(15, '[]', '[]', '[]', 0),
	(16, '[]', '[]', '[]', 0);

INSERT INTO `utk_keys` (`key`, `holder`) VALUES
    ('key_6_1', ''),
	('key_6_2', ''),
	('key_6_3', ''),
	('key_6_4', ''),
	('key_6_5', ''),
	('key_6_6', ''),
	('key_6_7', ''),
	('key_6_8', ''),
	('key_6_9', ''),
	('key_6_10', ''),
	('key_6_11', ''),
	('key_6_12', ''),
	('key_6_13', ''),
	('key_6_14', ''),
	('key_6_15', ''),
	('key_6_16', '');