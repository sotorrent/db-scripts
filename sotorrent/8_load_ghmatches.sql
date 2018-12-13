USE `sotorrent18_12`;

SET foreign_key_checks = 0;
# load file exported from BigQuery (see also https://cloud.google.com/sql/docs/mysql/import-export/)
LOAD DATA LOCAL INFILE 'GHMatches.csv' INTO TABLE `GHMatches`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(FileId, MatchedLine);
SET foreign_key_checks = 1;
