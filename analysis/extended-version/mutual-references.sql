--- retrieve posts and comments referencing GitHub repos

#standardsql
SELECT
  Id,
  PostId,
  PostHistoryId, 
  REGEXP_EXTRACT(Path, r'^([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)') AS Repo,
  REGEXP_EXTRACT(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(.*)') AS Path
FROM `sotorrent-org.2019_06_21.PostVersionUrl`
WHERE RootDomain = "github.com"
  AND REGEXP_CONTAINS(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+'); 
  
=> so-tests.2019_06_21.PostVersionUrlGH

#standardsql
SELECT
  Id,
  PostId,
  CommentId, 
  REGEXP_EXTRACT(Path, r'^([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)') AS Repo,
  REGEXP_EXTRACT(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(.*)') AS Path
FROM `sotorrent-org.2019_06_21.CommentUrl`
WHERE RootDomain = "github.com"
  AND REGEXP_CONTAINS(Path, r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+'); 
  
=> so-tests.2019_06_21.CommentUrlGH

#standardsql
SELECT
  PostId,
  Repo
FROM `so-tests.2019_06_21.PostVersionUrlGH`
GROUP BY PostId, Repo
UNION DISTINCT
SELECT
  PostId,
  Repo
FROM `so-tests.2019_06_21.CommentUrlGH`;

=> so-tests.2019_06_21.LinksFromSOToGH


--- retrieve posts referencing GitHub repos, which are themselves referenced from the repo

#standardsql
SELECT
  gh.Repo AS Repo,
  FileId,
  FileExt,
  gh.PostId AS PostId,
  gh.SOUrl AS SOUrl,
  gh.GHUrl AS GHUrl
FROM `sotorrent-org.2019_06_21.PostReferenceGH` gh
JOIN `so-tests.2019_06_21.LinksFromSOToGH` so
ON gh.Repo = so.Repo
	AND gh.PostId = so.PostId
GROUP BY Repo, FileId, FileExt, PostId, SOUrl, GHUrl;

=> so-tests.2019_06_21.MutualReferences


#standardsql
SELECT
  gh_threads.Repo AS Repo,
  FileId,
  FileExt,
  gh_threads.ParentId AS ParentId,
  gh_threads.PostId AS PostId,
  SOUrl,
  GHUrl
FROM (
  SELECT
    gh.Repo AS Repo,
    FileId,
    FileExt,
    threads1.ParentId,
    gh.PostId AS PostId,
    gh.SOUrl AS SOUrl,
    gh.GHUrl AS GHUrl
  FROM `sotorrent-org.2019_06_21.PostReferenceGH` gh
  JOIN `sotorrent-org.2019_06_21.Threads` threads1
  ON gh.PostId = threads1.PostId
) AS gh_threads
JOIN (
  SELECT 
    so.PostId AS PostId,
    so.Repo AS Repo,
    threads2.ParentId AS ParentId
  FROM `so-tests.2019_06_21.LinksFromSOToGH` so
  JOIN `sotorrent-org.2019_06_21.Threads` threads2
  ON so.PostId = threads2.PostId
) AS so_threads 
ON gh_threads.Repo = so_threads.Repo
  AND gh_threads.ParentId = so_threads.ParentId
GROUP BY Repo, FileId, FileExt, ParentId, PostId, SOUrl, GHUrl;

=> so-tests.2019_06_21.MutualReferencesThread
