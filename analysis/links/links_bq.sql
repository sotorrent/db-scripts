# add new column "Domain" to table PostVersionUrl
#standardsql
SELECT 
  Id,
  PostId,
  PostHistoryId,
  PostBlockVersionId,
  REGEXP_EXTRACT(Url, r'(?i:http|ftp|https)(?::\/\/)([\w_-]+(?:(?:\.[\w_-]+)+))') as Domain,
	Url
FROM `sotorrent-org.2018_03_28`.`PostVersionUrl`;

=> sotorrent-org.analysis_2018_03_28.PostVersionUrl

# retrieve all spring-related domains
#standardsql
SELECT Domain, COUNT(DISTINCT PostId) as PostCount
FROM `sotorrent-org.analysis_2018_03_28`.`PostVersionUrl`
WHERE Domain LIKE '%spring%'
GROUP BY Domain
ORDER BY PostCount DESC;

=> SpringLinks.csv

#standardsql
SELECT Domain, COUNT(DISTINCT PostId) as PostCount
FROM `sotorrent-org.analysis_2018_03_28`.`PostVersionUrl`
WHERE Domain LIKE '%oracle%' OR Domain LIKE '%java%' OR Domain LIKE '%jdk%'
GROUP BY Domain
ORDER BY PostCount DESC;

=> JavaLinks.csv


# retrieve post blocks of most recent version
#standardsql
SELECT *
FROM (
	SELECT *
	FROM `sotorrent-org.2018_03_28`.`PostBlockVersion`
	WHERE PostHistoryId IN (
		SELECT MAX(PostHistoryId)
		FROM `sotorrent-org.2018_03_28`.`PostVersion`
		GROUP BY PostId
	)
);

=> analysis_2018_03_28.PostBlockVersionRecent

# lines with comments about Google
#standardsql
SELECT
  Id,
  PostId,
  REGEXP_EXTRACT(LOWER(line), r'google(?:d){0,1}\s+(?:it|that|this)\s+') as Match,
  Line
FROM (
  SELECT Id, PostId, Line
  FROM (
    SELECT Id, PostId, SPLIT(Content, "&#xD;&#xA;") as lines
    FROM `sotorrent-org.analysis_2018_03_28`.`PostBlockVersionRecent`
    WHERE PostBlockTypeId = 1  # only consider text blocks
  )
  CROSS JOIN UNNEST(lines) as Line
)
WHERE
  REGEXP_CONTAINS(LOWER(Line), r'google(?:d){0,1}\s+(?:it|that|this)\s+');

=> analysis_2018_03_28.GoogleLines

