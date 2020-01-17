#standardsql
SELECT pv_outer.*, ViewCount-(
  SELECT MIN(ViewCount)
  FROM `sotorrent-org.2019_12_25.PostViews` pv_inner
  WHERE PostId=3758606) AS ViewCountSince2016_09
FROM `sotorrent-org.2019_12_25.PostViews` pv_outer
WHERE PostId=3758606
ORDER BY Version DESC;