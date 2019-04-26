# retrieve posts and comments referencing GitHub repos
SELECT
  Id,
  PostId,
  PostHistoryId, 
  REGEXP_EXTRACT(Path, r'^([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)') AS Repo,
  REGEXP_EXTRACT(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(.*)') AS Path
FROM `sotorrent-org.2019_03_17.PostVersionUrl`
WHERE RootDomain = "github.com"
  AND REGEXP_CONTAINS(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+'); 
  
=> sotorrent-extension.2019_03_17.PostVersionUrlGH

SELECT
  Id,
  PostId,
  CommentId, 
  REGEXP_EXTRACT(Path, r'^([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)') AS Repo,
  REGEXP_EXTRACT(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(.*)') AS Path
FROM `sotorrent-org.2019_03_17.CommentUrl`
WHERE RootDomain = "github.com"
  AND REGEXP_CONTAINS(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+'); 
  
=> sotorrent-extension.2019_03_17.CommentUrlGH

SELECT
  PostId,
  Repo
FROM `sotorrent-extension.mutual_references.PostVersionUrlGH`
GROUP BY PostId, Repo
UNION DISTINCT
SELECT
  PostId,
  Repo
FROM `sotorrent-extension.mutual_references.CommentUrlGH`;

=> sotorrent-extension.2019_03_17.SOLinksGH


# retrieve posts referencing GitHub repos, which are themselves referenced from the repo
SELECT
  gh.Repo AS Repo,
  FileId,
  FileExt,
  gh.PostId AS PostId,
  gh.SOUrl AS SOUrl,
  gh.GHUrl AS GHUrl
FROM `sotorrent-org.2019_03_17.PostReferenceGH` gh
JOIN `sotorrent-extension.mutual_references.SOLinksGH` so
ON gh.Repo = so.Repo
	AND gh.PostId = so.PostId
GROUP BY Repo, FileId, FileExt, PostId, SOUrl, GHUrl;

=> sotorrent-extension.2019_03_17.MutualReferences
