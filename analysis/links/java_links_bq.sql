
# create tables with Java questions, answers, and posts

#standardsql
SELECT *
FROM `sotorrent-org.2018_03_28`.`Posts`
WHERE PostTypeId = 1
    AND LOWER(Tags) LIKE '%<java>%';

=> analysis_2018_03_28.JavaQuestions

#standardsql
SELECT *
FROM `sotorrent-org.2018_03_28`.`Posts`
WHERE PostTypeId = 2 AND ParentId IN (
    SELECT Id
    FROM `sotorrent-org.analysis_2018_03_28`.`JavaQuestions`
);

=> analysis_2018_03_28.JavaAnswers

#standardsql
SELECT * from `sotorrent-org.analysis_2018_03_28`.`JavaQuestions`
UNION ALL
SELECT * FROM `sotorrent-org.analysis_2018_03_28`.`JavaAnswers`;

=> analysis_2018_03_28.JavaPosts

# retrieve references collected from most recent version of SO Java posts
#standardsql
SELECT
	urls.Id as Id,
  PostId,
  PostTypeId,
  PostHistoryId,
  PostBlockVersionId,
  REGEXP_EXTRACT(Url, r'(?i:http|ftp|https)(?::\/\/)([\w_-]+(?:(?:\.[\w_-]+)+))') as Domain,
	Url
FROM (
	SELECT *
	FROM `sotorrent-org.2018_03_28`.`PostVersionUrl`
	WHERE PostHistoryId IN (
		SELECT MAX(PostHistoryId)
		FROM `sotorrent-org.2018_03_28`.`PostVersionUrl`
		GROUP BY PostId
	)
) urls
JOIN `sotorrent-org.analysis_2018_03_28`.`JavaPosts` posts
ON urls.PostId = posts.Id;

=> analysis_2018_03_28.JavaPostLinks

#standardsql
SELECT
	urls.Id as Id,
  PostId,
  urls.PostTypeId as PostTypeId,
  PostHistoryId,
  PostBlockVersionId,
  Domain,
  Url
FROM (
	SELECT *
	FROM `sotorrent-org.analysis_2018_03_28`.`JavaPostLinks`
	WHERE PostHistoryId IN (
		SELECT MAX(PostHistoryId)
		FROM `sotorrent-org.2018_03_28`.`PostVersionUrl`
		GROUP BY PostId
	)
) urls
JOIN `sotorrent-org.analysis_2018_03_28`.`JavaQuestions` posts
ON urls.PostId = posts.Id;

=> analysis_2018_03_28.JavaQuestionLinks

#standardsql
SELECT
	urls.Id as Id,
  PostId,
  urls.PostTypeId as PostTypeId,
  PostHistoryId,
  PostBlockVersionId,
  Domain,
  Url
FROM (
	SELECT *
	FROM `sotorrent-org.analysis_2018_03_28`.`JavaPostLinks`
	WHERE PostHistoryId IN (
		SELECT MAX(PostHistoryId)
		FROM `sotorrent-org.2018_03_28`.`PostVersionUrl`
		GROUP BY PostId
	)
) urls
JOIN `sotorrent-org.analysis_2018_03_28`.`JavaAnswers` posts
ON urls.PostId = posts.Id;

=> analysis_2018_03_28.JavaAnswerLinks

# group by domains

#standardsql
SELECT Domain, COUNT(DISTINCT PostId) as PostCount
FROM `sotorrent-org.analysis_2018_03_28`.`JavaQuestionLinks`
GROUP BY Domain
ORDER BY PostCount DESC
LIMIT 100;

=> JavaQuestionLinksTop100.csv

#standardsql
SELECT Domain, COUNT(DISTINCT PostId) as PostCount
FROM `sotorrent-org.analysis_2018_03_28`.`JavaAnswerLinks`
GROUP BY Domain
ORDER BY PostCount DESC
LIMIT 100;

=> JavaAnswerLinksTop100.csv
