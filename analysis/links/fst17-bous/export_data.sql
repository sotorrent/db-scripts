USE `analysis`;

# create tables with Java questions, answers, and posts
CREATE TABLE `JavaQuestions` AS
SELECT * FROM sotorrent17_12.`Posts`
WHERE PostTypeId = 1
    AND LOWER(Tags) LIKE '%<java>%';

CREATE TABLE`JavaAnswers` AS
SELECT * FROM sotorrent17_12.`Posts`
WHERE PostTypeId = 2
    AND ParentId IN (SELECT Id FROM `JavaQuestions`);

CREATE TABLE `JavaPosts` AS
SELECT * from `JavaQuestions`
UNION ALL
SELECT * FROM `JavaAnswers`;

# export references from GH files to SO Java posts
SELECT
	FileId,
	RepoName,
	Branch,
	Path,
	FileExt,
	Size,
	Copies,
	PostId,
	refs.PostTypeId as PostTypeId,
	Score,
	CommentCount,
	SOUrl,
	GHUrl
INTO OUTFILE 'F:/Temp/PostReferenceGH_Java.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM sotorrent17_12.`PostReferenceGH` refs
JOIN `JavaPosts` posts
ON refs.PostId = posts.Id;

# export references collected from SO Java posts
SELECT
	urls.Id as Id,
    PostId,
    PostTypeId,
    PostHistoryId,
    PostBlockVersionId,
    Url
INTO OUTFILE 'F:/Temp/PostVersionUrl_Java.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM (
	SELECT *
	FROM sotorrent17_12.`PostVersionUrl`
	WHERE PostHistoryId IN (
		SELECT MAX(PostHistoryId)
		FROM sotorrent17_12.`PostVersionUrl`
		GROUP BY PostId
	)
) urls
JOIN `JavaPosts` posts
ON urls.PostId = posts.Id;
