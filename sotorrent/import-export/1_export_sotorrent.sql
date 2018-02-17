# Add secure-file-priv="/data/tmp/" under [mysqld] in my.ini or /etc/mysql/mysql.conf.d/mysqld.cnf
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

USE `sotorrent17_12`;

SELECT *
INTO OUTFILE '/data/tmp/PostBlockDiff.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostBlockDiff`;

SELECT *
INTO OUTFILE '/data/tmp/PostBlockDiffOperation.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostBlockDiffOperation`;

SELECT *
INTO OUTFILE '/data/tmp/PostBlockType.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostBlockType`;

SELECT *
INTO OUTFILE '/data/tmp/PostBlockVersion.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostBlockVersion`;

SELECT *
INTO OUTFILE '/data/tmp/PostType.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostType`;

SELECT *
INTO OUTFILE '/data/tmp/PostVersion.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostVersion`;

SELECT *
INTO OUTFILE '/data/tmp/PostVersionUrl.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostVersionUrl`;
