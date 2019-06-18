USE `sotorrent19_06`;

CREATE INDEX `comments_index_1` ON Comments(UserId);
CREATE INDEX `comments_index_2` ON Comments(UserDisplayName);

CREATE INDEX `post_history_index_1` ON PostHistory(UserId);
CREATE INDEX `post_history_index_2` ON PostHistory(UserDisplayName);

CREATE INDEX `posts_index_1` ON Posts(OwnerUserId);
CREATE INDEX `posts_index_2` ON Posts(LastEditorUserId);
CREATE INDEX `posts_index_3` ON Posts(OwnerDisplayName);

CREATE INDEX `users_index_1` ON Users(DisplayName);
