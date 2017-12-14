USE `sotorrent17_12`;

CREATE INDEX `comments_index_1` ON Comments(UserId);

CREATE INDEX `post_history_index_1` ON PostHistory(UserId);

CREATE INDEX `posts_index_1` ON Posts(OwnerUserId);
CREATE INDEX `posts_index_2` ON Posts(LastEditorUserId);
