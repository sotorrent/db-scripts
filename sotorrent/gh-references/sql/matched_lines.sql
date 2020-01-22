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
