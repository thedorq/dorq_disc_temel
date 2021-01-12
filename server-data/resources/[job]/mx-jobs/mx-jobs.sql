INSERT INTO `items` (`name`, `label`, `weight`) VALUES
	('altin', 'Altın', 1),
	('demir', 'Demir', 1),
	('elmas', 'Elmas', 1),
	('kiyafet', 'Kıyafet', 1),
	('kumas', 'Kumaş', 1),
	('portakal', 'Portakal', 1),
	('portakalsuyu', 'Portakal Suyu', 1),
	('sarap', 'Şarap', 1),
	('tavuk', 'Tavuk', 1),
	('paketlenmistavuk', 'Paketlenmiş Tavuk', 1),
	('uzum', 'Uzum', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('kasap', 'Kasap'),
	('terzi', 'Terzi'),
	('maden', 'Maden')
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('terzi', 0, 'isci', 'İşci', 0, '{}', '{}'),
	('kasap', 0, 'isci', 'İşci', 0, '{}', '{}'),
	('maden', 0, 'isci', 'İşci', 0, '{}', '{}')
;

ALTER TABLE `users` ADD COLUMN `mainjoblimit` INT(11) NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD COLUMN `sidejoblimit` INT(11) NOT NULL DEFAULT '0';
 
