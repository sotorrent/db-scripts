# Export tables from offical SO dump to CSV to be able to import them into BigQuery

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
INTO OUTFILE '<PATH>Users.csv'
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
INTO OUTFILE '<PATH>Badges.csv'
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
INTO OUTFILE '<PATH>Posts.csv' 
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
INTO OUTFILE '<PATH>Comments.csv' 
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
INTO OUTFILE '<PATH>PostHistory.csv' 
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
INTO OUTFILE '<PATH>PostLinks.csv' 
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
INTO OUTFILE '<PATH>Tags.csv' 
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
INTO OUTFILE '<PATH>Votes.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM `Votes`;
