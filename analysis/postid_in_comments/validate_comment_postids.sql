# there seem to be comments for posts that do not exist anymore
#standardsql
SELECT DISTINCT PostId
FROM `sotorrent-org.2018_03_28.Comments`
WHERE PostId NOT IN (SELECT Id FROM `sotorrent-org.2018_03_28.Posts`);

=> deprecated_postids.csv
(234 post ids)

