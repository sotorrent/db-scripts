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
