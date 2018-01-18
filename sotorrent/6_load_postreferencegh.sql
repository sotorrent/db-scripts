USE `sotorrent17_12`;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostReferenceGH.csv' INTO TABLE `PostReferenceGH`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SET foreign_key_checks = 1;
