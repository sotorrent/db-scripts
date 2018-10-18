SELECT
  pbv.Id as Id,
  PostBlockTypeId,
  PostId,
  PostTypeId,
  CASE
  	WHEN ParentId IS NULL THEN PostId
  	ELSE ParentId
  END as ParentId,
  LocalId,
  Length,
  LineCount,
  Content,
  REGEXP_REPLACE(Content, r'\s|(&#xA;)|(&#xD;)|[^a-zA-Z0-9]', '') as ContentNormalized
FROM
  `sotorrent-org.2018_09_23.PostBlockVersion` pbv
JOIN
	`sotorrent-org.2018_09_23.Posts` p
ON
	pbv.PostId = p.Id
WHERE
  PostHistoryId = (
	  SELECT
	    MAX(PostHistoryId)
	  FROM
	    `sotorrent-org.2018_09_23.PostVersion` pv
	  WHERE
	    pv.PostId = pbv.PostId
	);

=> sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalized

SELECT
	FARM_FINGERPRINT(ContentNormalized) AS ContentNormalizedHash,
	PostBlockTypeId,
  AVG(LineCount) AS AvgLineCount,
	COUNT(DISTINCT ParentId) AS ThreadCount,
	ContentNormalized
FROM
	`sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalized`
GROUP BY
	ContentNormalized, PostBlockTypeId;

=> sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClones

SELECT
	ContentNormalizedHash,
	PostBlockTypeId,
  AvgLineCount,
	ThreadCount
FROM
	`sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClones`;

=> sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClonesHash

