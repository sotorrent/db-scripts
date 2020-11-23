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

# create helper table that makes it easier to retrieve the parent id of a thread
CREATE TABLE Threads AS
SELECT
  Id as PostId,
  PostTypeId,
  CASE
    WHEN PostTypeId=1 THEN Id
    WHEN PostTypeId=2 THEN ParentId
  END as ParentId
FROM Posts
# only consider questions and answers
WHERE PostTypeId=1
  OR PostTypeId=2;
