#standardSQL
SELECT
  file_id,
  repo_name,
  REGEXP_EXTRACT(ref, r'refs/heads/(.+)') as branch,
  REGEXP_REPLACE(path, r'(\r\n?|\n)', '') as path,
  LOWER(REGEXP_EXTRACT(path, r'(\.[^.\\\/:\s]+)\s*$')) as file_ext,
  size,
  post_id,
  comment_id,
  url,
  line
FROM (
  SELECT id, repo_name, ref, path
  FROM `bigquery-public-data.github_repos.files`
) as files
JOIN `sotorrent-org.<DATASET>.matched_lines_aq` as lines
ON lines.file_id = files.id;

