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
FROM `sotorrent-org.<DATASET>.matched_lines_aq` as lines
LEFT JOIN `bigquery-public-data.github_repos.files` as files
ON lines.file_id = files.id;

