SET foreign_key_checks = 0;
LOAD DATA INFILE  '<PATH>PostViews.csv' INTO TABLE `PostViews`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(PostId, ViewCount)
SET Version = STR_TO_DATE('<VERSION>', '%Y-%m-%d');
SET foreign_key_checks = 1;
