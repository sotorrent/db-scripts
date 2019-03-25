# Export tables from offical SO dump to CSV to be able to import them into BigQuery

USE `sotorrent19_03`;

# Users
SELECT
  Id,
  Reputation,
  IFNULL(CreationDate, ''),
  IFNULL(DisplayName, ''),
  IFNULL(LastAccessDate, ''),
  IFNULL(WebsiteUrl, ''),
  IFNULL(Location, ''),
  IFNULL(ProfileImageUrl, ''),
  IFNULL(AboutMe, ''),
  IFNULL(Views, ''),
  IFNULL(UpVotes, ''),
  IFNULL(DownVotes, ''),
  IFNULL(Age, ''),
  IFNULL(AccountId, ''),
  IFNULL(EmailHash, '')
INTO OUTFILE 'F:/Temp/Users.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `Users`;

# Badges
SELECT
  Id,
  UserId,
  IFNULL(Name, ''),
  IFNULL(Date, ''),
  IFNULL(Class, ''),
  IFNULL(TagBased, '')
INTO OUTFILE 'F:/Temp/Badges.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `Badges`;

# Posts
SELECT
  Id,
  IFNULL(PostTypeId, ''),
  IFNULL(AcceptedAnswerId, ''),
  IFNULL(ParentId, ''),
  IFNULL(CreationDate, ''),
  IFNULL(DeletionDate, ''),
  IFNULL(Score, ''),
  IFNULL(ViewCount, ''),
  IFNULL(REPLACE(Body, '\n', '&#xD;&#xA;'), ''),
  IFNULL(OwnerUserId, ''),
  IFNULL(OwnerDisplayName, ''),
  IFNULL(LastEditorUserId, ''),
  IFNULL(LastEditorDisplayName, ''),
  IFNULL(LastEditDate, ''),
  IFNULL(LastActivityDate, ''),
  IFNULL(Title, ''),
  IFNULL(Tags, ''),
  IFNULL(AnswerCount, ''),
  IFNULL(CommentCount, ''),
  IFNULL(FavoriteCount, ''),
  IFNULL(ClosedDate, ''),
  IFNULL(CommunityOwnedDate, '')
INTO OUTFILE 'F:/Temp/Posts.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `Posts`;

# Comments
SELECT
  Id,
  PostId,
  Score,
  IFNULL(REPLACE(Text, '\n', '&#xD;&#xA;'), ''),
  IFNULL(CreationDate, ''),
  IFNULL(UserDisplayName, ''),
  IFNULL(UserId, '')
INTO OUTFILE 'F:/Temp/Comments.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `Comments`;

# PostHistory
SELECT
  Id,
  PostHistoryTypeId,
  PostId,
  IFNULL(RevisionGUID, ''),
  IFNULL(CreationDate, ''),
  IFNULL(UserId, ''),
  IFNULL(UserDisplayName, ''),
  IFNULL(REPLACE(Comment, '\n', '&#xD;&#xA;'), ''),
  IFNULL(REPLACE(Text, '\n', '&#xD;&#xA;'), '')
INTO OUTFILE 'F:/Temp/PostHistory.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostHistory`;

# PostLinks
SELECT
  Id,
  IFNULL(CreationDate, ''),
  PostId,
  RelatedPostId,
  IFNULL(LinkTypeId, '')
INTO OUTFILE 'F:/Temp/PostLinks.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `PostLinks`;

# Tags
SELECT
  Id,
  IFNULL(TagName, ''),
  IFNULL(Count, ''),
  IFNULL(ExcerptPostId, ''),
  IFNULL(WikiPostId, '')
INTO OUTFILE 'F:/Temp/Tags.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `Tags`;

# Votes
SELECT
  Id,
  PostId,
  IFNULL(VoteTypeId, ''),
  IFNULL(UserId, ''),
  IFNULL(CreationDate, ''),
  IFNULL(BountyAmount, '')
INTO OUTFILE 'F:/Temp/Votes.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `Votes`;
