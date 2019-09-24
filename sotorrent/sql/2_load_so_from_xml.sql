SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>Users.xml'
INTO TABLE `Users`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>Badges.xml'
INTO TABLE `Badges`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>Posts.xml'
INTO TABLE `Posts`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>Comments.xml'
INTO TABLE `Comments`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>PostHistory.xml'
INTO TABLE `PostHistory`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>PostLinks.xml'
INTO TABLE `PostLinks`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>Tags.xml'
INTO TABLE `Tags`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD XML INFILE '<PATH>Votes.xml'
INTO TABLE `Votes`
ROWS IDENTIFIED BY '<row>';
SET foreign_key_checks = 1;
