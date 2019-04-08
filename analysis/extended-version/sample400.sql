
# import EditedThreads_Sample400.csv first

# retrieve content of text blocks together with post metadata
SELECT tbc.PostId as PostId, ParentId, PostHistoryId, TextBlockContent
FROM (
  SELECT PostId, PostHistoryId, STRING_AGG(Content, "&#xD;&#xA;") as TextBlockContent
  FROM (
    SELECT pbv.PostId AS PostId, PostHistoryId, Content
    FROM `sotorrent-extension.sample_400.EditedThreads_Sample400` s
    JOIN `sotorrent-org.2019_03_17.PostBlockVersion` pbv
    ON s.PostId = pbv.PostId AND pbv.PostBlockTypeId = 1
    ORDER BY PostId ASC, PostHistoryId ASC, LocalId ASC
  ) 
  GROUP BY PostId, PostHistoryId
) tbc
JOIN `sotorrent-org.2019_03_17.Threads` t
ON tbc.PostId = t.PostId;

=> EditedThreads_Sample400TextBlocks 

SELECT COUNT(DISTINCT PostId)
FROM `sotorrent-extension.sample_400.EditedThreads_Sample400TextBlocks`;

=> 399 (one post deleted in the meantime)
