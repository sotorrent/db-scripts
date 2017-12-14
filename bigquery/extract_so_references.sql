--- Status: 20.11.2017
--- Execute this in BigQuery

--- TODO: Check extraction of SO references (e.g. post 3758880)

--- Select all source code lines of text files that contain a link to Stack Overflow
SELECT
  file_id,
  size,
  copies,
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
    copies,
    line
  FROM (
    SELECT
      id as file_id,
      size,
      copies,
      SPLIT(content, '\n') as lines
    FROM `bigquery-public-data.github_repos.contents`
    WHERE
      binary = false
      AND content is not null
  )
  CROSS JOIN UNNEST(lines) as line  
)
WHERE REGEXP_CONTAINS(line, r'(?i:https?://stackoverflow\.com/[^\s)\.\"]*)');

=> so_references_2017_11_20.matched_lines


--- Join with table files to get information about repos
SELECT
  lines.file_id as file_id,
  repo_name,
  REGEXP_EXTRACT(ref, r'refs/heads/(.+)') as branch,
  path,
  size,
  copies,
  url,
  line
FROM `soposthistory.so_references_2017_11_20.matched_lines` as lines
LEFT JOIN `bigquery-public-data.github_repos.files` as files
ON lines.file_id = files.id;

=> so_references_2017_11_20.matched_files


--- Normalize the SO links to (http://stackoverflow.com/(a/q)/<id>)
SELECT
  file_id,
  repo_name,
  branch,
  path,
  size,
  copies,
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
FROM `soposthistory.so_references_2017_11_20.matched_files`;

=> so_references_2017_11_20.matched_files_normalized


--- Extract post id from links, set post type id, and extract file extension from path
SELECT
  file_id,
  repo_name,
  branch,
  path,
  LOWER(REGEXP_EXTRACT(path, r'(\.[^.]+$)')) as file_ext,
  size,
  copies,
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
FROM `soposthistory.so_references_2017_11_20.matched_files_normalized`
WHERE
  REGEXP_CONTAINS(url, r'(http:\/\/stackoverflow\.com\/(?:a|q)\/[\d]+)');
  
=> so_references_2017_11_20.matched_files_aq


--- Use camel case for column names and remove line content for export into MySQL database
SELECT
  file_id as FileId,
  repo_name as RepoName,
  branch as Branch,
  path as Path,
  file_ext as FileExt,
  size as Size,
  copies as Copies,
  post_id as PostId,
  post_type_id as PostTypeId,
  url as Url
FROM `soposthistory.so_references_2017_11_20.matched_files_aq`;

=> so_references_2017_11_20.PostReferenceGH

--- TODO: merge with SO data

--- Retrieve info about referenced SO answers
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
      Url,
      PostId,
      PostTypeId,
      comment_count As CommentCount,
      score as Score,
      parent_id as ParentId
    FROM `soposthistory.so_references_2017_11_20.PostReferenceGH` ref
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
  Url,
  PostId,
  PostTypeId,
  CommentCount,
  answers.Score as Score,
  ParentId,
  view_count as ParentViewCount
FROM answers
LEFT JOIN `bigquery-public-data.stackoverflow.posts_questions` q
ON answers.ParentId = q.id;

=> so_references_2017_11_20.PostReferenceGH_Answers

SELECT
  FileId,
  FileExt,
  PostId,
  PostTypeId,
  CommentCount,
  Score,
  ParentViewCount
FROM `soposthistory.so_references_2017_11_20.PostReferenceGH_Answers`;

=> so_references_2017_11_20.PostReferenceGH_Answers_R


--- Retrieve info about referenced SO questions
SELECT
  FileId,
  RepoName,
  Branch,
  Path,
  FileExt,
  Size,
  Copies,
  Url,
  PostId,
  PostTypeId,
  comment_count As CommentCount,
  score as Score,
  view_count as ViewCount
FROM `soposthistory.so_references_2017_11_20.PostReferenceGH` ref
LEFT JOIN `bigquery-public-data.stackoverflow.posts_questions` q
ON ref.PostId = q.id
WHERE PostTypeId=1;

=> so_references_2017_11_20.PostReferenceGH_Questions

SELECT
  FileId,
  FileExt,
  PostId,
  PostTypeId,
  CommentCount,
  Score,
  ViewCount
FROM `soposthistory.so_references_2017_11_20.PostReferenceGH_Questions`;


=> so_references_2017_11_20.PostReferenceGH_Questions_R


--- Retrieve information about all Java questions to compare referenced questions with all questions
SELECT
  id as post_id,
  REGEXP_CONTAINS(tags, r'(?:^|.+\|)(java)(?:\||$)') as java_tag,
  REGEXP_CONTAINS(tags, r'(?:^|.+\|)(android)(?:\||$)') as android_tag,
  score,
  comment_count,
  view_count
FROM `bigquery-public-data.stackoverflow.posts_questions`
WHERE REGEXP_CONTAINS(tags, r'(?:^|.+\|)(java|android)(?:\||$)');

=> so_java.questions

--- Retrieve information about all Java answers to compare referenced answers with all answers
SELECT
  answers.id as post_id,
  answers.parent_id as parent_id,
  java_questions.java_tag as java_tag,
  java_questions.android_tag as android_tag,
  answers.score as score,
  answers.comment_count as comment_count,
  java_questions.view_count as parent_view_count
FROM `bigquery-public-data.stackoverflow.posts_answers` answers
INNER JOIN `soposthistory.so_java.questions` java_questions
ON java_questions.post_id = answers.parent_id;

=> so_java.answers
