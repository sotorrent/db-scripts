#standardSQL
SELECT file_id, repo_name, branch, path, file_ext, size, post_id, comment_id, url, line
FROM `sotorrent-org.gh_so_references_2019_03_29.matched_files_aq`
WHERE 
  --- use PostHistory instead of Posts to also cover deleted posts
  post_id IN (SELECT DISTINCT PostId FROM `sotorrent-org.2019_03_17.PostHistory`) AND
  (comment_id IS NULL OR comment_id IN (SELECT DISTINCT Id FROM `sotorrent-org.2019_03_17.Comments`));

