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
  FROM `sotorrent-org.<DATASET>.matched_files_aq`
  GROUP BY FileId, PostId, MatchedLine
)
GROUP BY FileId, MatchedLine;
