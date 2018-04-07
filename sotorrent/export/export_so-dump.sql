# Export tables Posts and PostHistory to CSV to be able to import them into BigQuery

USE `sotorrent18_03`;

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
