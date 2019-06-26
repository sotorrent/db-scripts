#standardSQL
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


