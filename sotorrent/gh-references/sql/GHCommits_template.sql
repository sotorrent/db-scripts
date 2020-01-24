#standardSQL
SELECT
  CommitId,
  Repo,
  RepoOwner,
  RepoName,
  PostId,
  CommentId,
  SOUrl,
  GHUrl
FROM (
  SELECT
    CommitId,
    Repo,
    RepoArray[OFFSET(0)] AS RepoOwner,
    RepoArray[OFFSET(1)] AS RepoName,
    CAST(REGEXP_EXTRACT(SOUrl, r'https:\/\/stackoverflow\.com\/(?:a|q)\/([\d]+)') AS INT64) as PostId,
    CASE
      WHEN REGEXP_CONTAINS(LOWER(SOUrl), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment[\d]+_[\d]+')
      THEN CAST(REGEXP_EXTRACT(LOWER(SOUrl), r'https?:\/\/(?:www.)?stackoverflow\.com\/questions\/[\d]+\/[^\s\/#]+#comment([\d]+)_[\d]+') AS INT64)
      ELSE NULL
    END AS CommentId,
    SOUrl,
    CONCAT(CONCAT(CONCAT("https://github.com/", Repo), "/commit/"), CAST(CommitId AS STRING)) AS GHUrl
  FROM (
    SELECT
      commit AS CommitId,
      repo_name as Repo,
      SPLIT(repo_name, "/") as RepoArray,
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
      END AS SOUrl
    FROM (
      SELECT commit, repo_name, urls
      FROM (
        SELECT
          commit,
          repo_name,
          REGEXP_EXTRACT_ALL(LOWER(message), r'(https?:\/\/(?:www.)?stackoverflow\.com\/(?:[a-zA-Z0-9\-_#/\\?=+&%;]*[a-zA-Z0-9/])?)') as urls
        FROM
          `bigquery-public-data.github_repos.commits`
        WHERE REGEXP_CONTAINS(LOWER(message), r'https?:\/\/(?:www.)?stackoverflow\.com\/[^\s)."]*')
      )
      CROSS JOIN UNNEST(repo_name) as repo_name
    )
    CROSS JOIN UNNEST(urls) as url
  )
)
WHERE 
  --- use PostHistory instead of Posts to also cover deleted posts
  PostId IN (SELECT DISTINCT PostId FROM `sotorrent-org.<SOTORRENT>.PostHistory`) AND
  (CommentId IS NULL OR CommentId IN (SELECT DISTINCT Id FROM `sotorrent-org.<SOTORRENT>.Comments`));
