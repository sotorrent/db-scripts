USE `sotorrent17_12`;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostBlockDiff.csv' INTO TABLE `PostBlockDiff`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostBlockDiffOperation.csv' INTO TABLE `PostBlockDiffOperation`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostBlockType.csv' INTO TABLE `PostBlockType`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostBlockVersion.csv' INTO TABLE `PostBlockVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostReferenceGH.csv' INTO TABLE `PostReferenceGH`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostType.csv' INTO TABLE `PostType`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostVersion.csv' INTO TABLE `PostVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'PostVersionUrl.csv' INTO TABLE `PostVersionUrl`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n';
SET foreign_key_checks = 1;
