SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `PostBlockDiff` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA INFILE  '<PATH>PostBlockDiff.csv' INTO TABLE `PostBlockDiff`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, PostHistoryId, LocalId, PostBlockVersionId, PredPostHistoryId, PredLocalId, PredPostBlockVersionId, PostBlockDiffOperationId, @Text)
SET Text = REPLACE(@Text, '&#xD;&#xA;', '\n');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `PostVersion` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA INFILE  '<PATH>PostVersion.csv' INTO TABLE `PostVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, PostTypeId, PostHistoryId, PostHistoryTypeId, CreationDate, @PredPostHistoryId, @SuccPostHistoryId, MostRecentVersion)
SET PredPostHistoryId = nullif(@PredPostHistoryId, ''),
	SuccPostHistoryId = nullif(@SuccPostHistoryId, '');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `PostBlockVersion` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA INFILE  '<PATH>PostBlockVersion.csv' INTO TABLE `PostBlockVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostBlockTypeId, PostId, PostHistoryId, LocalId, @PredPostBlockVersionId, @PredPostHistoryId, @PredLocalId, @RootPostBlockVersionId, @RootPostHistoryId, @RootLocalId, @PredEqual, @PredSimilarity, @PredCount, @SuccCount, Length, LineCount, @Content, MostRecentVersion)
SET Content = REPLACE(@Content, '&#xD;&#xA;', '\n'),
    PredPostBlockVersionId = nullif(@PredPostBlockVersionId, ''),
    PredPostHistoryId = nullif(@PredPostHistoryId, ''),
    PredLocalId = nullif(@PredLocalId, ''),
    RootPostBlockVersionId = nullif(@RootPostBlockVersionId, ''),
    RootPostHistoryId = nullif(@RootPostHistoryId, ''),
    RootLocalId = nullif(@RootLocalId, ''),
    PredEqual = nullif(@PredEqual, ''),
    PredSimilarity = nullif(@PredSimilarity, ''),
    PredCount = nullif(@PredCount, ''),
    SuccCount = nullif(@SuccCount, '');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `PostVersionUrl` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA INFILE  '<PATH>PostVersionUrl.csv' INTO TABLE `PostVersionUrl`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, PostHistoryId, PostBlockVersionId, LinkType, LinkPosition, @LinkAnchor, Protocol, RootDomain, CompleteDomain, @Path, @Query, @FragmentIdentifier, Url, @FullMatch)
SET LinkAnchor = nullif(REPLACE(@LinkAnchor, '&#xD;&#xA;', '\n'), ''),
	Path = nullif(@Path, ''),
	Query = nullif(@Query, ''),
	FragmentIdentifier = nullif(@FragmentIdentifier, ''),
	FullMatch = REPLACE(@FullMatch, '&#xD;&#xA;', '\n');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `CommentUrl` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA INFILE  '<PATH>CommentUrl.csv' INTO TABLE `CommentUrl`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, CommentId, LinkType, LinkPosition, @LinkAnchor, Protocol, RootDomain, CompleteDomain, @Path, @Query, @FragmentIdentifier, Url, @FullMatch)
SET LinkAnchor = nullif(REPLACE(@LinkAnchor, '&#xD;&#xA;', '\n'), ''),
	Path = nullif(@Path, ''),
	Query = nullif(@Query, ''),
	FragmentIdentifier = nullif(@FragmentIdentifier, ''),
	FullMatch = REPLACE(@FullMatch, '&#xD;&#xA;', '\n');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `TitleVersion` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA INFILE  '<PATH>TitleVersion.csv' INTO TABLE `TitleVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, PostTypeId, PostHistoryId, PostHistoryTypeId, CreationDate, Title, @PredPostHistoryId, @PredEditDistance, @SuccPostHistoryId, @SuccEditDistance, MostRecentVersion)
SET PredPostHistoryId = nullif(@PredPostHistoryId, ''),
	PredEditDistance = nullif(@PredEditDistance, ''),
	SuccPostHistoryId = nullif(@SuccPostHistoryId, ''),
	SuccEditDistance = nullif(@SuccEditDistance, '');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `StackSnippetVersion` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA INFILE  '<PATH>StackSnippetVersion.csv' INTO TABLE `StackSnippetVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, PostTypeId, PostHistoryId, @Content)
SET Content = REPLACE(@Content, '&#xD;&#xA;', '\n');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
LOAD DATA INFILE  '<PATH>PostViews.csv' INTO TABLE `PostViews`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(PostId, Version, ViewCount)
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# load file exported from BigQuery (see also https://cloud.google.com/sql/docs/mysql/import-export/)
LOAD DATA INFILE  '<PATH>PostReferenceGH.csv' INTO TABLE `PostReferenceGH`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(FileId, Repo, RepoOwner, RepoName, Branch, Path, FileExt, Size, Copies, PostId, @CommentId, SOUrl, GHUrl)
SET CommentId = nullif(@CommentId, '');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# load file exported from BigQuery (see also https://cloud.google.com/sql/docs/mysql/import-export/)
LOAD DATA INFILE  '<PATH>GHMatches.csv' INTO TABLE `GHMatches`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(FileId, PostIds, @MatchedLine)
SET MatchedLine = REPLACE(@MatchedLine, '&#xD;&#xA;', '\n');
SET foreign_key_checks = 1;
