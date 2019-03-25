USE `sotorrent19_03`;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/Users.xml'
INTO TABLE `Users`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/Badges.xml'
INTO TABLE `Badges`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/Posts.xml'
INTO TABLE `Posts`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/Comments.xml'
INTO TABLE `Comments`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/PostHistory.xml'
INTO TABLE `PostHistory`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/PostLinks.xml'
INTO TABLE `PostLinks`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/Tags.xml'
INTO TABLE `Tags`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE 'F:/Temp/Votes.xml'
INTO TABLE `Votes`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;
