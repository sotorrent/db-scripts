USE `sotorrent19_06`;

SET foreign_key_checks = 0;
# load file exported from BigQuery (see also https://cloud.google.com/sql/docs/mysql/import-export/)
LOAD DATA INFILE  'F:/Temp/GHMatches.csv' INTO TABLE `GHMatches`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(FileId, PostIds, @MatchedLine)
SET MatchedLine = REPLACE(@MatchedLine, '&#xD;&#xA;', '\n');
SET foreign_key_checks = 1;
