USE `analysis_18_03`;

# retrieve edited posts and join with parents (null for answers)
CREATE TABLE EditedPosts AS
SELECT PostsWithEdits.PostId as PostId, PostTypeId, ParentId
FROM
(SELECT DISTINCT(PostId) as PostId
FROM sotorrent18_03.PostBlockVersion
WHERE PredCount>0 and PredEqual=0) as PostsWithEdits
LEFT JOIN
(SELECT Id as PostId, PostTypeId, ParentId
FROM sotorrent18_03.Posts) as PostParents
ON PostsWithEdits.PostId = PostParents.PostId;

# create indices
CREATE INDEX `edited_posts_index_1` ON EditedPosts(PostId);
CREATE INDEX `edited_posts_index_2` ON EditedPosts(PostTypeId);
CREATE INDEX `edited_posts_index_3` ON EditedPosts(ParentId);

# write post ids of threads with edits
# (edited questions and questions with edited answers)
SELECT PostId
INTO OUTFILE 'F:/Temp/EditedPosts.csv'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
FROM
# questions with edits
(SELECT PostId FROM analysis_18_03.EditedPosts
WHERE PostTypeId = 1
UNION DISTINCT
# questions for answers with edits
SELECT ParentId as PostId
FROM analysis_18_03.EditedPosts
WHERE PostTypeId = 2) as posts;
