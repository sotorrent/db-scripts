# normalize post blocks, calculate normalized line count, calculate fingerprint of normalized content
SELECT
  Id,
  PostBlockTypeId,
  PostId,
  PostTypeId,
  ParentId,
  LineCount,
  LineCountNormalized,
  FARM_FINGERPRINT(ContentNormalized) AS ContentNormalizedHash,
  Content,
  ContentNoEmptyLines,
  ContentNormalized
FROM (
  SELECT
    Id,
    PostBlockTypeId,
    PostId,
    PostTypeId,
    ParentId,
    LineCount,
    ARRAY_LENGTH(SPLIT(ContentNoEmptyLines, '&#xD;&#xA;')) AS LineCountNormalized,
    Content,
    ContentNoEmptyLines,
    REGEXP_REPLACE(ContentNoEmptyLines, r'\s|(&#xA;)|(&#xD;)|[^a-zA-Z0-9]', '') AS ContentNormalized
  FROM (
    SELECT
      pbv.Id AS Id,
  	  PostBlockTypeId,
	  PostId,
	  PostTypeId,
	  CASE
	    WHEN ParentId IS NULL THEN PostId
	    ELSE ParentId
	  END AS ParentId,
	  LineCount,
	  Content,
	  REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(Content,
	    r'\s*[()[\]{}]+\s*&#xD;\s*&#xA;\s*', ''), # remove lines only containing brackets
	    r'(\s*&#xD;\s*&#xA;\s*)+', '&#xD;&#xA;'), # normalize new lines
	    r'(\s*&#xD;\s*&#xA;\s*)+$', '') # remove new lines in last line
	    AS ContentNoEmptyLines
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
      )
  )
);

=> sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalized
  

# count clones
SELECT
  ContentNormalizedHash,
  PostBlockTypeId,
  STRING_AGG(CAST(PostId AS STRING), ' ') AS PostIds,
  MIN(LineCountNormalized) AS LineCount,
  COUNT(DISTINCT ParentId) AS ThreadCount,
  ContentNormalized
FROM
	`sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalized`
GROUP BY
	ContentNormalizedHash, ContentNormalized, PostBlockTypeId;

=> sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClones


# copy clones without content (for export)
SELECT
  ContentNormalizedHash,
  PostBlockTypeId,
  PostIds,
  LineCount,
  ThreadCount
FROM
	`sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClones`;

=> sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClonesExport


# retrieve sample for web visualization
SELECT
  ContentNormalizedHash,
  PostId,
  PostTypeId,
  ParentId
FROM
  `sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalized`
WHERE 
  ContentNormalizedHash IN (
    SELECT
      ContentNormalizedHash
    FROM 
      `sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClones`
    WHERE
      PostBlockTypeId = 2 AND LineCount > 5 AND ThreadCount >= 10
);

=> sotorrent-extension.2018_09_23.CodeClonesSample


# retrieve data for sample
SELECT
  ContentNormalizedHash,
  ARRAY_LENGTH(SPLIT(Content, '&#xD;&#xA;')) AS LineCount,
  ThreadCount,
  Content
FROM (
  SELECT
    clones.ContentNormalizedHash AS ContentNormalizedHash,
    MIN(Content) as Content,
	MAX(ThreadCount) as ThreadCount
  FROM
    `sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalized` post_blocks
  JOIN
    `sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClones` clones
  ON
    post_blocks.ContentNormalizedHash = clones.ContentNormalizedHash
  WHERE
    clones.PostBlockTypeId = 2 AND clones.LineCount > 5 AND ThreadCount >= 10
  GROUP BY ContentNormalizedHash
);

=> sotorrent-extension.2018_09_23.CodeClonesSampleData


# Retrieve links from posts containing clones
SELECT
  ContentNormalizedHash,
  clones.PostId,
  PostTypeId,
  ParentId,
  RootDomain,
  CompleteDomain,
  Url
FROM
  `sotorrent-org.2018_09_23.PostVersionUrl` post_version_url
JOIN
  `sotorrent-extension.2018_09_23.CodeClonesSample` clones
ON
  post_version_url.PostId = clones.PostId
WHERE
  PostHistoryId = (
  SELECT
    MAX(PostHistoryId)
  FROM
    `sotorrent-org.2018_09_23.PostVersion` pv
  WHERE
    pv.PostId = post_version_url.PostId
  );
  
=> sotorrent-extension.2018_09_23.CodeClonesSampleLinks
  

# Retrieve and normalize SO links
SELECT
  ContentNormalizedHash,
  PostId,
  PostTypeId,
  ParentId,
  REGEXP_EXTRACT(Url, r'https:\/\/stackoverflow\.com\/(?:a|q)\/([\d]+)') AS LinkedPostId,
  CASE
	WHEN REGEXP_CONTAINS(Url, r'https:\/\/stackoverflow\.com\/q') THEN 1
	WHEN REGEXP_CONTAINS(Url, r'https:\/\/stackoverflow\.com\/a') THEN 2
	ELSE NULL
  END AS LinkedPostTypeId,
  Url
FROM (
  SELECT
    ContentNormalizedHash,
    PostId,
    PostTypeId,
    ParentId,
    CASE
      WHEN REGEXP_CONTAINS(Url, r'(https:\/\/stackoverflow\.com\/a\/[\d]+)')
	    THEN REGEXP_EXTRACT(Url, r'(https:\/\/stackoverflow\.com\/a\/[\d]+)')
      WHEN REGEXP_CONTAINS(Url, r'(https:\/\/stackoverflow\.com\/q\/[\d]+)')
	    THEN REGEXP_EXTRACT(Url, r'(https:\/\/stackoverflow\.com\/q\/[\d]+)')
      WHEN REGEXP_CONTAINS(Url, r'https:\/\/stackoverflow\.com\/questions\/[\d]+\/[^\s\/\#]+(?:\/|\#)([\d]+)')
	    THEN CONCAT("https://stackoverflow.com/a/", REGEXP_EXTRACT(Url, r'https:\/\/stackoverflow\.com\/questions\/[\d]+\/[^\s\/\#]+(?:\/|\#)([\d]+)'))
      WHEN REGEXP_CONTAINS(Url, r'(https:\/\/stackoverflow\.com\/questions\/[\d]+)')
	    THEN CONCAT("https://stackoverflow.com/q/", REGEXP_EXTRACT(Url, r'https:\/\/stackoverflow\.com\/questions\/([\d]+)'))
      ELSE Url
    END AS Url
  FROM (
    SELECT
      ContentNormalizedHash,
      PostId,
      PostTypeId,
      ParentId,
      REGEXP_REPLACE(LOWER(Url), r'^http:', 'https:') AS Url
    FROM
      `sotorrent-extension.2018_09_23.CodeClonesSampleLinks`
    WHERE
      RootDomain = "stackoverflow.com"
   )
);

=> sotorrent-extension.2018_09_23.CodeClonesSampleLinksSO


# Count SO links per code block hash
SELECT ContentNormalizedHash, LinkedPostId, LinkedPostTypeId, COUNT(PostId) AS PostCount
FROM `sotorrent-extension.2018_09_23.CodeClonesSampleLinksSO`
WHERE LinkedPostId IS NOT NULL
GROUP BY ContentNormalizedHash, LinkedPostId, LinkedPostTypeId;

=> sotorrent-extension.2018_09_23.CodeClonesSampleLinksSOExport


# Count non-SO links per code block hash
SELECT ContentNormalizedHash, Url, COUNT(PostId) AS PostCount
FROM `sotorrent-extension.2018_09_23.CodeClonesSampleLinks`
WHERE RootDomain <> "stackoverflow.com"
GROUP BY ContentNormalizedHash, Url;

=> sotorrent-extension.2018_09_23.CodeClonesSampleLinksNonSOExport



# retrieve data to analysis linking of clones
SELECT
  ContentNormalizedHash,
  PostId,
  PostTypeId,
  ParentId
FROM
  `sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalized`
WHERE 
  ContentNormalizedHash IN (
    SELECT
      ContentNormalizedHash
    FROM 
      `sotorrent-extension.2018_09_23.MostRecentPostBlockVersionNormalizedClones`
    WHERE
      PostBlockTypeId = 2 AND LineCount > 5 AND ThreadCount >= 2
);

=> sotorrent-extension.2018_09_23.CodeClonesSampleLarge


# Retrieve and normalize SO links
SELECT
  ContentNormalizedHash,
  PostId,
  PostTypeId,
  ParentId,
  REGEXP_EXTRACT(Url, r'https:\/\/stackoverflow\.com\/(?:a|q)\/([\d]+)') AS LinkedPostId,
  CASE
	WHEN REGEXP_CONTAINS(Url, r'https:\/\/stackoverflow\.com\/q') THEN 1
	WHEN REGEXP_CONTAINS(Url, r'https:\/\/stackoverflow\.com\/a') THEN 2
	ELSE NULL
  END AS LinkedPostTypeId,
  Url
FROM (
  SELECT
    ContentNormalizedHash,
    PostId,
    PostTypeId,
    ParentId,
    CASE
      WHEN REGEXP_CONTAINS(Url, r'(https:\/\/stackoverflow\.com\/a\/[\d]+)')
	    THEN REGEXP_EXTRACT(Url, r'(https:\/\/stackoverflow\.com\/a\/[\d]+)')
      WHEN REGEXP_CONTAINS(Url, r'(https:\/\/stackoverflow\.com\/q\/[\d]+)')
	    THEN REGEXP_EXTRACT(Url, r'(https:\/\/stackoverflow\.com\/q\/[\d]+)')
      WHEN REGEXP_CONTAINS(Url, r'https:\/\/stackoverflow\.com\/questions\/[\d]+\/[^\s\/\#]+(?:\/|\#)([\d]+)')
	    THEN CONCAT("https://stackoverflow.com/a/", REGEXP_EXTRACT(Url, r'https:\/\/stackoverflow\.com\/questions\/[\d]+\/[^\s\/\#]+(?:\/|\#)([\d]+)'))
      WHEN REGEXP_CONTAINS(Url, r'(https:\/\/stackoverflow\.com\/questions\/[\d]+)')
	    THEN CONCAT("https://stackoverflow.com/q/", REGEXP_EXTRACT(Url, r'https:\/\/stackoverflow\.com\/questions\/([\d]+)'))
      ELSE Url
    END AS Url
  FROM (
    SELECT
      ContentNormalizedHash,
      PostId,
      PostTypeId,
      ParentId,
      REGEXP_REPLACE(LOWER(Url), r'^http:', 'https:') AS Url
    FROM (
	SELECT
	  ContentNormalizedHash,
	  clones.PostId,
	  PostTypeId,
	  ParentId,
	  RootDomain,
	  CompleteDomain,
	  Url
	FROM
	  `sotorrent-org.2018_09_23.PostVersionUrl` post_version_url
	JOIN
	  `sotorrent-extension.2018_09_23.CodeClonesSampleLarge` clones
	ON
	  post_version_url.PostId = clones.PostId
	WHERE
	  PostHistoryId = (
	  SELECT
		MAX(PostHistoryId)
	  FROM
		`sotorrent-org.2018_09_23.PostVersion` pv
	  WHERE
		pv.PostId = post_version_url.PostId
	  )
    ) WHERE
      RootDomain = "stackoverflow.com"
   )
);

=> sotorrent-extension.2018_09_23.CodeClonesSampleLargeLinksSO


# Export links to SO questions or answers
SELECT
  ContentNormalizedHash,
  PostId,
  PostTypeId,
  ParentId,
  LinkedPostId,
  LinkedPostTypeId
FROM
  `sotorrent-extension.2018_09_23.CodeClonesSampleLargeLinksSO`
WHERE
  LinkedPostId IS NOT NULL;

=> sotorrent-extension.2018_09_23.CodeClonesSampleLargeLinksSOExport
