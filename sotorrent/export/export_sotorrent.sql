# Add secure-file-priv="<output_path>" under [mysqld] in my.ini or /etc/mysql/mysql.conf.d/mysqld.cnf
# to allow file export to that directory. Windows paths without backslashes, e.g., F:/Temp
# Alternatively, disable secure-file-priv by setting it to ""
# If AppArmor is activated for MySQL, the MySQL profile has to be modified to allow accessing /data/tmp/:
#  sudo nano /etc/apparmor.d/local/usr.sbin.mysqld
#  # Site-specific additions and overrides for usr.sbin.mysqld.
#  # For more details, please see /etc/apparmor.d/local/README.
#  /data/tmp/ r,
#  /data/tmp/** rwk,
#  sudo service apparmor reload
# Alternative: Temporarily disable AppArmor for MySQL
# (see, e.g., https://www.cyberciti.biz/faq/ubuntu-linux-howto-disable-apparmor-commands/)

USE `sotorrent19_03`;

SELECT Id, PostId, PostHistoryId, LocalId, PostBlockVersionId, PredPostHistoryId, PredLocalId, PredPostBlockVersionId, PostBlockDiffOperationId, REPLACE(Text, '\n', '&#xD;&#xA;')
INTO OUTFILE 'F:/Temp/PostBlockDiff.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostBlockDiff`;

SELECT Id, PostId, PostTypeId, PostHistoryId, PostHistoryTypeId, CreationDate, IFNULL(PredPostHistoryId, ''), IFNULL(SuccPostHistoryId, ''), MostRecentVersion
INTO OUTFILE 'F:/Temp/PostVersion.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostVersion`;

SELECT Id, PostBlockTypeId, PostId, PostHistoryId, LocalId, IFNULL(PredPostBlockVersionId, ''), IFNULL(PredPostHistoryId, ''), IFNULL(PredLocalId, ''), IFNULL(RootPostBlockVersionId, ''), IFNULL(RootPostHistoryId, ''), IFNULL(RootLocalId, ''), IFNULL(PredEqual, ''), IFNULL(PredSimilarity, ''), IFNULL(PredCount, ''), IFNULL(SuccCount, ''), Length, LineCount, REPLACE(Content, '\n', '&#xD;&#xA;'), MostRecentVersion
INTO OUTFILE 'F:/Temp/PostBlockVersion.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostBlockVersion`;

SELECT Id, PostId, PostHistoryId, PostBlockVersionId, LinkType, LinkPosition, REPLACE(IFNULL(FullMatch, ''), '\n', '&#xD;&#xA;'), Protocol, RootDomain, CompleteDomain, IFNULL(Path, ''), IFNULL(Query, ''), IFNULL(FragmentIdentifier, ''), Url, REPLACE(FullMatch, '\n', '&#xD;&#xA;')
INTO OUTFILE 'F:/Temp/PostVersionUrl.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostVersionUrl`;

SELECT Id, PostId, CommentId, LinkType, LinkPosition, REPLACE(IFNULL(FullMatch, ''), '\n', '&#xD;&#xA;'), Protocol, RootDomain, CompleteDomain, IFNULL(Path, ''), IFNULL(Query, ''), IFNULL(FragmentIdentifier, ''), Url, REPLACE(FullMatch, '\n', '&#xD;&#xA;')
INTO OUTFILE 'F:/Temp/CommentUrl.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `CommentUrl`;

SELECT Id, PostId, PostTypeId, PostHistoryId, PostHistoryTypeId, CreationDate, REPLACE(Title, '\n', ' '), IFNULL(PredPostHistoryId, ''), IFNULL(PredEditDistance, ''), IFNULL(SuccPostHistoryId, ''), IFNULL(SuccEditDistance, '')
INTO OUTFILE 'F:/Temp/TitleVersion.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `TitleVersion`;
