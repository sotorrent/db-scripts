--- Execute this in BigQuery

--- "Table Info" of table "bigquery-public-data:github_repos.contents"
--- Last Modified: Mar 29, 2019, 7:49:02 AM 
--- Number of Rows: 258,409,596
--- Table Size: 2.19 TB 

--- select all source code lines of text files that contain a link to Stack Overflow
#standardSQL
SELECT
  file_id,
  size,
  url,
  line
FROM (
	SELECT
	  file_id,
	  size,
	  REGEXP_EXTRACT_ALL(LOWER(line), r'(https?:\/\/(?:www.)?stackoverflow\.com\/(?:[a-zA-Z0-9\-_#/\\?=+&%;]*[a-zA-Z0-9/])?)') as urls,
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
		  SPLIT(REGEXP_REPLACE(content, r'(\r\n?|\n)', '\n'), '\n') as lines
		FROM `bigquery-public-data.github_repos.contents`
		WHERE
		  binary = false AND
		  content is not null
	  )
	  CROSS JOIN UNNEST(lines) as line  
	)
	WHERE REGEXP_CONTAINS(LOWER(line), r'https?:\/\/(?:www.)?stackoverflow\.com\/[^\s)."]*')
)
CROSS JOIN UNNEST(urls) as url;

=> gh_so_references_2019_03_29.matched_lines


--- normalize the SO links, map them to http://stackoverflow.com/(a/q)/<id> or comment link
--- extract post id and comment id from links
SELECT
  file_id,
  size,
  CAST(REGEXP_EXTRACT(url, r'https:\/\/stackoverflow\.com\/(?:a|q)\/([\d]+)') AS INT64) as post_id,
  CASE
    WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment[\d]+_[\d]+')
    THEN CAST(REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment([\d]+)_[\d]+') AS INT64)
    ELSE NULL
  END AS comment_id,
  url,
  line
FROM (
  SELECT
    file_id,
    size,
    CASE
      --- DO NOT replace the distinction between answers and questions, because otherwise URLs like this won't be matched: http://stackoverflow.com/a/3758880/1035417
      WHEN REGEXP_CONTAINS(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/(?:questions|q|a)\/\d+\/[^\s\/#]+(?:\/\d+)?(?:\?[^\s\/#]+)?#comment\d+_\d+')
        THEN CONCAT(
          CONCAT("https://stackoverflow.com/q/",
            REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/([\d]+)')), --- question id
          CONCAT(CONCAT(CONCAT(
            "#comment",
            REGEXP_EXTRACT(LOWER(url), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/\d+\/[^\s\/#]+(?:\/\d+)?(?:\?[^\s\/#]+)?#comment(\d+)_\d+'))), --- comment id
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
    line
  FROM `sotorrent-org.gh_so_references_2019_03_29.matched_lines`
)
WHERE REGEXP_CONTAINS(url, r'(https:\/\/stackoverflow\.com\/(?:a|q)\/[\d]+)');

=> gh_so_references_2019_03_29.matched_lines_aq


--- join with table "files" to get information about repositories
--- extract file extension from path
#standardSQL
SELECT
  lines.file_id as file_id,
  repo_name,
  REGEXP_EXTRACT(ref, r'refs/heads/(.+)') as branch,
  REGEXP_REPLACE(path, r'(\r\n?|\n)', '') as path,
  LOWER(REGEXP_EXTRACT(path, r'(\.[^.\\\/:\s]+)\s*$')) as file_ext,
  size,
  post_id,
  comment_id,
  url,
  line
FROM `sotorrent-org.gh_so_references_2019_03_29.matched_lines_aq` as lines
LEFT JOIN `bigquery-public-data.github_repos.files` as files
ON lines.file_id = files.id;

=> gh_so_references_2019_03_29.matched_files_aq


--- validate post ids and comments ids

SELECT file_id, repo_name, branch, path, file_ext, size, post_id, comment_id, url, line
FROM `sotorrent-org.gh_so_references_2019_03_29.matched_files_aq`
WHERE 
  --- use PostHistory instead of Posts to also cover deleted posts
  post_id IN (SELECT DISTINCT PostId FROM `sotorrent-org.2019_03_17.PostHistory`) AND
  (comment_id IS NULL OR comment_id IN (SELECT DISTINCT Id FROM `sotorrent-org.2019_03_17.Comments`));

=> gh_so_references_2019_03_29.matched_files_aq_filtered


--- use camel case for column names, add number of copies, and split repo name for export to MySQL database
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

=> gh_so_references_2019_03_29.PostReferenceGH


--- save matched lines is a separate table
#standardSQL
SELECT
  FileId,
  STRING_AGG(CAST(PostId AS STRING), " ") as PostIds,
  MatchedLine
FROM (
  SELECT
    file_id as FileId,
    post_id as PostId,
    --- prevent error "Bad character (ASCII 0) encountered" when importing into BigQuery again
    REGEXP_REPLACE(REGEXP_REPLACE(line, r'[\r\n]+', '&#xD;&#xA;'), r'\x00', '') as MatchedLine
  FROM `sotorrent-org.gh_so_references_2019_03_29.matched_files_aq`
  GROUP BY FileId, PostId, MatchedLine
)
GROUP BY FileId, MatchedLine;

=> gh_so_references_2019_03_29.GHMatches
