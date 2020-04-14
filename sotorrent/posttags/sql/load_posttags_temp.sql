SET foreign_key_checks = 0;
LOAD DATA INFILE  '<PATH>PostTagsTemp.csv' INTO TABLE `PostTagsTemp`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(PostId, Tag);
SET foreign_key_checks = 1;
