# retrieve posts referencing GitHub repos

SELECT
  Id,
  PostId,
  PostHistoryId, 
  REGEXP_EXTRACT(Path, r'^([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)') AS RepoName,
  REGEXP_EXTRACT(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(.*)') AS Path
FROM `sotorrent-org.2018_09_23.PostVersionUrl`
WHERE RootDomain = "github.com"
  AND REGEXP_CONTAINS(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+');

=> sotorrent-org.tmp.PostVersionUrlGH

# retrieve posts referencing GitHub repos, which are themselves referenced from the repo

SELECT
  FileId,
  gh.RepoName AS RepoName,
  gh.PostId AS PostId,
  PostTypeId,
  PostHistoryId,
  Id as LinkId 
FROM `sotorrent-org.2018_09_23.PostReferenceGH` gh
JOIN `sotorrent-org.tmp.PostVersionUrlGH` so
ON gh.RepoName = so.RepoName
	AND gh.PostId = so.PostId;

=> sotorrent-org.tmp.MutualReferences


SELECT PostId, RepoName
FROM `sotorrent-org.tmp.MutualReferences`
GROUP BY PostId, RepoName;

=> sotorrent-org.tmp.UniqueMutualReferences


SELECT COUNT(*)
FROM `sotorrent-org.tmp.UniqueMutualReferences`;

=> 547
