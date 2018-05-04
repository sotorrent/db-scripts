--- Status: 2018-05-04
--- Execute this in BigQuery

--- select all source code lines of text files that contain a link to Stack Overflow
#standardSQL
SELECT
  file_id,
  size,
  REGEXP_REPLACE(
      REGEXP_EXTRACT(LOWER(line), r'(https?://stackoverflow\.com/[^\s)\.\"]*)'),
      r'(^https)',
      'http'
  ) as url,
  line
FROM (
  SELECT
    file_id,
    size,
    line
  FROM (
    SELECT
      id as file_id,
      size,
      SPLIT(content, '\n') as lines
    FROM `bigquery-public-data.github_repos.contents`
    WHERE
      binary = false AND
      content is not null
  )
  CROSS JOIN UNNEST(lines) as line  
)
WHERE REGEXP_CONTAINS(line, r'(?i:https?://stackoverflow\.com/[^\s)\.\"]*)');

=> gh_so_references_2018_05_04.matched_lines


--- join with table "files" to get information about repos
#standardSQL
SELECT
  lines.file_id as file_id,
  repo_name,
  REGEXP_EXTRACT(ref, r'refs/heads/(.+)') as branch,
  path,
  size,
  url,
  line
FROM `sotorrent-org.gh_so_references_2018_05_04.matched_lines` as lines
LEFT JOIN `bigquery-public-data.github_repos.files` as files
ON lines.file_id = files.id;

=> gh_so_references_2018_05_04.matched_files


--- normalize the SO links to (http://stackoverflow.com/(a/q)/<id>)
#standardSQL
SELECT
  file_id,
  repo_name,
  branch,
  REPLACE(path, '\n', '') as path,
  size,
  CASE
    --- DO NOT replace the distinction between answers and questions, because otherwise URLs like this won't be matched: http://stackoverflow.com/a/3758880/1035417
    WHEN REGEXP_CONTAINS(LOWER(url), r'(https?:\/\/stackoverflow\.com\/a\/[\d]+)')
    THEN CONCAT("http://stackoverflow.com/a/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/stackoverflow\.com\/a\/([\d]+)'))
    WHEN REGEXP_CONTAINS(LOWER(url), r'(https?:\/\/stackoverflow\.com\/q\/[\d]+)')
    THEN CONCAT("http://stackoverflow.com/q/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/stackoverflow\.com\/q\/([\d]+)'))
    WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/stackoverflow\.com\/questions\/[\d]+\/[^\s\/\#]+(?:\/|\#)([\d]+)')
    THEN CONCAT("http://stackoverflow.com/a/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/stackoverflow\.com\/questions\/[\d]+\/[^\s\/\#]+(?:\/|\#)([\d]+)'))
    WHEN REGEXP_CONTAINS(LOWER(url), r'(https?:\/\/stackoverflow\.com\/questions\/[\d]+)')
    THEN CONCAT("http://stackoverflow.com/q/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/stackoverflow\.com\/questions\/([\d]+)'))
    ELSE url
  END as url,
  line
FROM `sotorrent-org.gh_so_references_2018_05_04.matched_files`;

=> gh_so_references_2018_05_04.matched_files_normalized


--- extract post id from links, set post type id, and extract file extension from path
#standardSQL
SELECT
  file_id,
  repo_name,
  branch,
  path,
  LOWER(REGEXP_EXTRACT(path, r'(\.[^.\\\/:]+$)')) as file_ext,
  size,
  CAST(REGEXP_EXTRACT(url, r'http:\/\/stackoverflow\.com\/(?:a|q)\/([\d]+)') AS INT64) as post_id,
  CASE
    WHEN REGEXP_CONTAINS(url, r'(http:\/\/stackoverflow\.com\/q\/[\d]+)')
    THEN 1
    WHEN REGEXP_CONTAINS(url, r'(http:\/\/stackoverflow\.com\/a\/[\d]+)')
    THEN 2
    ELSE NULL
  END as post_type_id,
  url,
  line
FROM `sotorrent-org.gh_so_references_2018_05_04.matched_files_normalized`
WHERE
  REGEXP_CONTAINS(url, r'(http:\/\/stackoverflow\.com\/(?:a|q)\/[\d]+)');
  
=> gh_so_references_2018_05_04.matched_files_aq


--- use camel case for column names, add number of copies, and remove line content for export to MySQL database
#standardSQL
WITH
	copies AS (
		SELECT file_id, count(*) as copies
		FROM `sotorrent-org.gh_so_references_2018_05_04.matched_files_aq`
		GROUP BY file_id
	)
SELECT
  files.file_id as FileId,
  repo_name as RepoName,
  branch as Branch,
  path as Path,
  file_ext as FileExt,
  size as Size,
  copies.copies as Copies,
  post_id as PostId,
  post_type_id as PostTypeId,
  url as SOUrl,
  CONCAT('https://raw.githubusercontent.com/', repo_name, "/", branch, "/", path) as GHUrl
FROM `sotorrent-org.gh_so_references_2018_05_04.matched_files_aq` files
JOIN copies
ON files.file_id = copies.file_id;

=> gh_so_references_2018_05_04.PostReferenceGH



###################################################################
# the following tables are not present in gh_so_references_2018_05_04
# will only be created on demand
###################################################################

--- retrieve info about referenced SO answers
#standardSQL
WITH
  answers AS (
    SELECT
      FileId,
      RepoName,
      Branch,
      Path,
      FileExt,
      Size,
      Copies,
      PostId,
      PostTypeId,
      comment_count As CommentCount,
      score as Score,
      parent_id as ParentId,
	  SOUrl,
	  GHUrl
    FROM `sotorrent-org.gh_so_references_2018_05_04.PostReferenceGH` ref
    LEFT JOIN `bigquery-public-data.stackoverflow.posts_answers` a
    ON ref.PostId = a.id
    WHERE PostTypeId=2
  )
SELECT 
  FileId,
  RepoName,
  Branch,
  Path,
  FileExt,
  Size,
  Copies,
  PostId,
  PostTypeId,
  CommentCount,
  answers.Score as Score,
  ParentId,
  view_count as ParentViewCount,
  SOUrl,
  GHUrl
FROM answers
LEFT JOIN `bigquery-public-data.stackoverflow.posts_questions` q
ON answers.ParentId = q.id;

=> gh_so_references_2018_05_04.PostReferenceGH_Answers


#standardSQL
SELECT
  FileId,
  FileExt,
  PostId,
  PostTypeId,
  CommentCount,
  Score,
  ParentViewCount
FROM `sotorrent-org.gh_so_references_2018_05_04.PostReferenceGH_Answers`;

=> gh_so_references_2018_05_04.PostReferenceGH_Answers_R


--- retrieve info about referenced SO questions
#standardSQL
SELECT
  FileId,
  RepoName,
  Branch,
  Path,
  FileExt,
  Size,
  Copies,
  PostId,
  PostTypeId,
  comment_count As CommentCount,
  score as Score,
  view_count as ViewCount,
  SOUrl,
  GHUrl
FROM `sotorrent-org.gh_so_references_2018_05_04.PostReferenceGH` ref
LEFT JOIN `bigquery-public-data.stackoverflow.posts_questions` q
ON ref.PostId = q.id
WHERE PostTypeId=1;

=> gh_so_references_2018_05_04.PostReferenceGH_Questions


#standardSQL
SELECT
  FileId,
  FileExt,
  PostId,
  PostTypeId,
  CommentCount,
  Score,
  ViewCount
FROM `sotorrent-org.gh_so_references_2018_05_04.PostReferenceGH_Questions`;

=> gh_so_references_2018_05_04.PostReferenceGH_Questions_R
