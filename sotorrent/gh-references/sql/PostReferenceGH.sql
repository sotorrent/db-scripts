#standardSQL
WITH
  copies AS (
    SELECT file_id, count(*) as copies
    FROM `sotorrent-org.gh_so_references_2019_03_29.matched_files_aq`
    GROUP BY file_id
  )
SELECT
  FileId,
  Repo,
  RepoArray[OFFSET(0)] AS RepoOwner,
  RepoArray[OFFSET(1)] AS RepoName,
  Branch,
  Path,
  FileExt,
  Size,
  Copies,
  PostId,
  CommentId,
  SOUrl,
  GHUrl
FROM (
  SELECT  
    files.file_id as FileId,
    repo_name as Repo,
    SPLIT(repo_name, "/") as RepoArray,
    branch as Branch,
    path as Path,
    file_ext as FileExt,
    size as Size,
    copies.copies as Copies,
    post_id as PostId,
    comment_id as CommentId,
    url as SOUrl,
    CONCAT('https://raw.githubusercontent.com/', repo_name, "/", branch, "/", path) as GHUrl
  FROM `sotorrent-org.gh_so_references_2019_03_29.matched_files_aq` files
  JOIN copies
  ON files.file_id = copies.file_id
);

