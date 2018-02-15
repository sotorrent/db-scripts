--- Status: 20.11.2017

--- retrieve information about all Java questions to compare referenced questions to all questions
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


--- retrieve information about all Java answers to compare referenced answers to all answers
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