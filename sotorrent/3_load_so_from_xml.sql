USE `sotorrent18_12`;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'Users.xml'
INTO TABLE `Users`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'Badges.xml'
INTO TABLE `Badges`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'Posts.xml'
INTO TABLE `Posts`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'Comments.xml'
INTO TABLE `Comments`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'PostHistory.xml'
INTO TABLE `PostHistory`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'PostLinks.xml'
INTO TABLE `PostLinks`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'Tags.xml'
INTO TABLE `Tags`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML LOCAL INFILE 'Votes.xml'
INTO TABLE `Votes`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;
