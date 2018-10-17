USE `analysis_18_09`;

# retrieve edited questions
CREATE TABLE EditedQuestions AS
SELECT
	PostId,
	PostTypeId,
	COUNT(PostHistoryId) as VersionCount,
	PostId as ParentId  # questions have themselves as parents
FROM sotorrent18_09.PostVersion
WHERE PostTypeId=1
GROUP BY PostId, PostTypeId, ParentId
HAVING VersionCount>1;
# add primary key
ALTER TABLE EditedQuestions ADD PRIMARY KEY(PostId);

# retrieve edited answers
CREATE TABLE EditedAnswers AS
SELECT
	PostId,
	pv.PostTypeId as PostTypeId,
	COUNT(PostHistoryId) as VersionCount,
	ParentId
FROM sotorrent18_09.PostVersion pv
JOIN sotorrent18_09.Posts p
ON pv.PostId = p.Id
WHERE pv.PostTypeId=2
GROUP BY PostId, PostTypeId, ParentId
HAVING VersionCount>1;
# add primary key
ALTER TABLE EditedAnswers ADD PRIMARY KEY(PostId);

# retrieve answers for edited questions
CREATE TABLE AnswersForEditedQuestions AS
SELECT
	a.PostId as PostId,
	a.PostTypeId as PostTypeId,
	a.VersionCount as VersionCount,
	a.ParentId as ParentId
FROM (
	SELECT
		PostId,
		pv.PostTypeId as PostTypeId,
		COUNT(PostHistoryId) as VersionCount,
		ParentId
	FROM sotorrent18_09.PostVersion pv
	JOIN sotorrent18_09.Posts p
	ON pv.PostId = p.Id
	WHERE pv.PostTypeId=2
	GROUP BY PostId, PostTypeId, ParentId
) a
JOIN EditedQuestions q
ON a.ParentId = q.PostId;
# add primary key
ALTER TABLE AnswersForEditedQuestions ADD PRIMARY KEY(PostId);

# retrieve questions for edited answers
CREATE TABLE QuestionsForEditedAnswers AS
SELECT
	q.PostId as PostId,
	q.PostTypeId as PostTypeId,
	q.VersionCount as VersionCount,
	q.PostId as ParentId
FROM (
	SELECT
		PostId,
		PostTypeId,
		COUNT(PostHistoryId) as VersionCount,
		PostId as ParentId  # questions have themselves as parents
	FROM sotorrent18_09.PostVersion pv
	WHERE PostTypeId=1
	GROUP BY PostId, PostTypeId, ParentId
) q
JOIN EditedAnswers a
ON q.PostId = a.ParentId
# more than one answer to this question may have been edited -> question appears more than once
GROUP BY PostId, PostTypeId, VersionCount, ParentId;
# add primary key
ALTER TABLE QuestionsForEditedAnswers ADD PRIMARY KEY(PostId);

# retrieve answers for questions for edited answers
CREATE TABLE AnswersForQuestionsForEditedAnswers AS
SELECT
	a.PostId as PostId,
	a.PostTypeId as PostTypeId,
	a.VersionCount as VersionCount,
	a.ParentId as ParentId
FROM (
	SELECT
		PostId,
		pv.PostTypeId as PostTypeId,
		COUNT(PostHistoryId) as VersionCount,
		ParentId
	FROM sotorrent18_09.PostVersion pv
	JOIN sotorrent18_09.Posts p
	ON pv.PostId = p.Id
	WHERE pv.PostTypeId=2
	GROUP BY PostId, PostTypeId, ParentId
) a
JOIN QuestionsForEditedAnswers q
ON a.ParentId = q.PostId;
# add primary key
ALTER TABLE AnswersForQuestionsForEditedAnswers ADD PRIMARY KEY(PostId);

# retrieve edited threads
CREATE TABLE EditedThreads AS
SELECT
	PostId,
	PostTypeId,
	VersionCount,
	ParentId
FROM (
	SELECT * FROM EditedQuestions
	UNION DISTINCT
	SELECT * FROM AnswersForEditedQuestions
	UNION DISTINCT
	SELECT * FROM EditedAnswers
	UNION DISTINCT
	SELECT * FROM QuestionsForEditedAnswers
	UNION DISTINCT
	SELECT * FROM AnswersForQuestionsForEditedAnswers
) edited_threads
ORDER BY ParentId, PostTypeId, PostId;
# add primary key
ALTER TABLE EditedThreads ADD PRIMARY KEY(PostId);

# export edited threads to CSV file
SELECT *
INTO OUTFILE 'F:/Temp/EditedThreads.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
FROM EditedThreads;


# get post owners
CREATE TABLE EditedThreadsOwners AS
SELECT
	t.PostId as PostId,
	OwnerUserId,
	OwnerDisplayName
FROM EditedThreads t
JOIN sotorrent18_09.Posts p
ON t.PostId = p.Id;
# add primary key
ALTER TABLE EditedThreadsOwners ADD PRIMARY KEY(PostId);

# export post owners to CSV file
SELECT *
INTO OUTFILE 'F:/Temp/EditedThreadsOwners.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
FROM EditedThreadsOwners;


# get edits for those threads (including editor)
CREATE TABLE EditedThreadsEdits AS
SELECT
	pv.PostId as PostId,
	PostTypeId,
	PostHistoryId,
	pv.PostHistoryTypeId as PostHistoryTypeId,
	pv.CreationDate as CreationDate,
	UserId,
	UserDisplayName,
	Comment
FROM sotorrent18_09.PostVersion pv
JOIN sotorrent18_09.PostHistory ph
ON pv.PostHistoryId = ph.Id
WHERE pv.PostId IN (SELECT DISTINCT PostId FROM EditedThreads);
# add primary key
ALTER TABLE EditedThreadsEdits ADD PRIMARY KEY(PostHistoryId);
ALTER TABLE EditedThreadsEdits ADD INDEX EditedThreadsEdits_index_1(PostId);
ALTER TABLE EditedThreadsEdits ADD INDEX EditedThreadsEdits_index_2(UserId);

# export post edits to CSV file
SELECT
	PostId,
	PostTypeId,
	PostHistoryId,
	PostHistoryTypeId,
	IFNULL(CreationDate, ''),
	IFNULL(UserId, ''),
	IFNULL(UserDisplayName, ''),
	IFNULL(REPLACE(REPLACE(Comment, '\n', '&#xD;&#xA;'), '"', ''), '')  # issues with R import
INTO OUTFILE 'F:/Temp/EditedThreadsEdits.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM EditedThreadsEdits;


# get comments for those threads
CREATE TABLE EditedThreadsComments AS
SELECT
	c.PostId as PostId,
	PostTypeId,
	Id as CommentId,
	CreationDate,
	UserId,
	UserDisplayName
FROM sotorrent18_09.Comments c
JOIN EditedThreads t
ON c.PostId = t.PostId;
# add primary key
ALTER TABLE EditedThreadsComments ADD PRIMARY KEY(CommentId);
ALTER TABLE EditedThreadsComments ADD INDEX EditedThreadsComments_index_1(PostId);
ALTER TABLE EditedThreadsComments ADD INDEX EditedThreadsComments_index_2(UserId);

# export post comments to CSV file
SELECT *
INTO OUTFILE 'F:/Temp/EditedThreadsComments.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
FROM EditedThreadsComments;
