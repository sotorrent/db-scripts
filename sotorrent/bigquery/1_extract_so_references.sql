--- Status: 2018-12-09
--- Execute this in BigQuery

--- select all source code lines of text files that contain a link to Stack Overflow
#standardSQL
SELECT
  file_id,
  size,
  REGEXP_REPLACE(
      REGEXP_EXTRACT(LOWER(line), r'(https?:\/\/(?:www.)?stackoverflow\.com\/[^\s)."]*)'),
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
WHERE REGEXP_CONTAINS(LOWER(line), r'https?:\/\/(?:www.)?stackoverflow\.com\/[^\s)."]*');

=> gh_so_references_2018_12_09.matched_lines


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
FROM `sotorrent-org.gh_so_references_2018_12_09.matched_lines` as lines
LEFT JOIN `bigquery-public-data.github_repos.files` as files
ON lines.file_id = files.id;

=> gh_so_references_2018_12_09.matched_files


--- normalize the SO links to (http://stackoverflow.com/(a/q)/<id>) + info whether link points to comment
#standardSQL
SELECT
  file_id,
  repo_name,
  branch,
  REPLACE(path, '\n', '') as path,
  size,
  CASE
    --- DO NOT replace the distinction between answers and questions, because otherwise URLs like this won't be matched: http://stackoverflow.com/a/3758880/1035417
    WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment[\d]+_[\d]+')
      THEN CONCAT(
        CONCAT("https://stackoverflow.com/q/",
          REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/([\d]+)')), --- question id
        CONCAT(CONCAT(CONCAT(
				  "#comment",
				  REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment([\d]+)_[\d]+'))), --- comment id
				  "_"),
				  REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/([\d]+)') --- question id
			)
	WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/a\/([\d]+)')
    THEN CONCAT("https://stackoverflow.com/a/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/a\/([\d]+)'))
    WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s#]+#([\d]+)')
    THEN CONCAT("https://stackoverflow.com/a/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s#]+#([\d]+)'))
	WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com/q/([\d]+)')
    THEN CONCAT("https://stackoverflow.com/q/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com/q/([\d]+)'))
    WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/([\d]+)')
    THEN CONCAT("https://stackoverflow.com/q/", REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/([\d]+)'))
    ELSE url
  END AS url,
  CASE
    WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment[\d]+_[\d]+')
    THEN CAST(REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment([\d]+)_[\d]+') AS INT64)
    ELSE NULL
  END AS comment_id,
  line
FROM `sotorrent-org.gh_so_references_2018_12_09.matched_files`;

=> gh_so_references_2018_12_09.matched_files_normalized


--- extract post id from links, set post type id, and extract file extension from path
#standardSQL
SELECT
  file_id,
  repo_name,
  branch,
  path,
  LOWER(REGEXP_EXTRACT(path, r'(\.[^.\\\/:]+$)')) as file_ext,
  size,
  CAST(REGEXP_EXTRACT(url, r'https:\/\/stackoverflow\.com\/(?:a|q)\/([\d]+)') AS INT64) as post_id,
  CASE
    WHEN REGEXP_CONTAINS(url, r'https:\/\/stackoverflow\.com\/q\/[\d]+#comment[\d]+_[\d]+')
	THEN 99 --- comment
	WHEN REGEXP_CONTAINS(url, r'(https:\/\/stackoverflow\.com\/q\/[\d]+)')
    THEN 1 --- question
    WHEN REGEXP_CONTAINS(url, r'(https:\/\/stackoverflow\.com\/a\/[\d]+)')
    THEN 2 --- answer
    ELSE NULL
  END as post_type_id,
  url,
  comment_id,
  line
FROM `sotorrent-org.gh_so_references_2018_12_09.matched_files_normalized`
WHERE
  REGEXP_CONTAINS(url, r'(https:\/\/stackoverflow\.com\/(?:a|q)\/[\d]+)');
  
=> gh_so_references_2018_12_09.matched_files_aq


--- use camel case for column names, add number of copies, and split repo name for export to MySQL database
#standardSQL
WITH
  copies AS (
    SELECT file_id, count(*) as copies
    FROM `sotorrent-org.gh_so_references_2018_12_09.matched_files_aq`
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
  PostTypeId,
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
    post_type_id as PostTypeId,
    comment_id as CommentId,
    url as SOUrl,
    CONCAT('https://raw.githubusercontent.com/', repo_name, "/", branch, "/", path) as GHUrl
  FROM `sotorrent-org.gh_so_references_2018_12_09.matched_files_aq` files
  JOIN copies
  ON files.file_id = copies.file_id
);

=> gh_so_references_2018_12_09.PostReferenceGH

--- save matched lines is a separate table
#standardSQL
SELECT
  file_id as FileId,
  --- prevent error "Bad character (ASCII 0) encountered" when importing into BigQuery again
  REGEXP_REPLACE(REGEXP_REPLACE(line, r'[\r\n]+', '&#xD;&#xA;'), r'\x00', '') as MatchedLine
FROM `sotorrent-org.gh_so_references_2018_12_09.matched_files_aq`
GROUP BY FileId, MatchedLine;

=> gh_so_references_2018_12_09.GHMatches
