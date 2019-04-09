
# import EditedThreads_Sample400.csv first

# retrieve all posts in threads
SELECT t.PostId as PostId, ParentId
FROM `sotorrent-extension.sample_400.EditedThreads_Sample400` s
JOIN `sotorrent-org.2019_03_17.Threads` t
ON s.PostId = t.ParentId;

=> Sample400_Posts

SELECT COUNT(*)
FROM `sotorrent-extension.sample_400.Sample400_Posts`;

=> 1,128

SELECT COUNT(DISTINCT PostId)
FROM `sotorrent-extension.sample_400.Sample400_Posts`
WHERE PostId = ParentId;

=> 399 (one thread deleted in the meantime)
  
# retrieve content of text blocks
SELECT PostId, ParentId, PostHistoryId, STRING_AGG(Content, "&#xD;&#xA;") as TextBlockContent
FROM (
  SELECT pbv.PostId AS PostId, ParentId, PostHistoryId, Content
  FROM `sotorrent-extension.sample_400.Sample400_Posts` s
  JOIN `sotorrent-org.2019_03_17.PostBlockVersion` pbv
  ON s.PostId = pbv.PostId AND pbv.PostBlockTypeId = 1
  ORDER BY PostId ASC, ParentId ASC, PostHistoryId ASC, LocalId ASC
) 
GROUP BY PostId, ParentId, PostHistoryId;

=> Sample400_Posts_TextBlocks 

SELECT COUNT(*)
FROM `sotorrent-extension.sample_400.Sample400_Posts_TextBlocks`;

=> 2,049

# retrieve content of comments
SELECT s.PostId AS PostId, ParentId, c.Id AS CommentId, Text AS CommentContent
FROM `sotorrent-extension.sample_400.Sample400_Posts` s
JOIN `sotorrent-org.2019_03_17.Comments` c
ON s.PostId = c.PostId
ORDER BY PostId ASC, ParentId ASC, CommentId ASC;

=> Sample400_Posts_Comments

SELECT COUNT(*)
FROM `sotorrent-extension.sample_400.Sample400_Posts_Comments`;

=> 2,255
