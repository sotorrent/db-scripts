#standardsql
SELECT
  Id as PostId,
  PostTypeId,
  CASE
    WHEN PostTypeId=1 THEN Id
    WHEN PostTypeId=2 THEN ParentId
  END as ParentId
FROM `sotorrent-org.2019_09_23.Posts`
WHERE PostTypeId=1  # only consider questions and answers
  OR PostTypeId=2; 