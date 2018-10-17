# add secure-file-priv="" under [mysqld] in my.ini

USE `stackoverflow17_06`;

# questions and answers
SELECT PostId, PostTypeId, VersionCount
INTO OUTFILE 'PostId_VersionCount_SO_Java_17-06.csv' 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM (
  # questions
  SELECT
    PostId, PostTypeId, COUNT(DISTINCT postHistory.Id) AS VersionCount
  FROM PostHistory postHistory INNER JOIN Posts posts
      ON postHistory.PostId = posts.Id
  WHERE
    PostTypeId=1
    AND PostHistoryTypeId IN (2, 5, 8)
    AND (LOWER(Tags) LIKE '%<java>%' OR LOWER(Tags) LIKE '%<android>%')
  GROUP BY PostId, PostTypeId
  UNION ALL
  # answers
SELECT
    PostId, PostTypeId, COUNT(DISTINCT postHistory.Id) AS VersionCount
  FROM PostHistory postHistory INNER JOIN Posts posts
      ON postHistory.PostId = posts.Id
  WHERE
    PostTypeId=2
    AND PostHistoryTypeId IN (2, 5, 8)
    AND ParentId IN (
      SELECT Id
      FROM Posts posts
      WHERE (LOWER(Tags) LIKE '%<java>%' OR LOWER(Tags) LIKE '%<android>%')
    )
  GROUP BY PostId, PostTypeId
) as questions_union_answers;
