USE `sotorrent18_09`;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `PostBlockDiff` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA LOCAL INFILE 'PostBlockDiff.csv' INTO TABLE `PostBlockDiff`
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
LOAD DATA LOCAL INFILE 'PostVersion.csv' INTO TABLE `PostVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, PostTypeId, PostHistoryId, PostHistoryTypeId, CreationDate, @PredPostHistoryId, @SuccPostHistoryId)
SET PredPostHistoryId = nullif(@PredPostHistoryId, ''),
	SuccPostHistoryId = nullif(@SuccPostHistoryId, '');
SET foreign_key_checks = 1;

SET foreign_key_checks = 0;
# remove auto-increment for import
ALTER TABLE `PostBlockVersion` MODIFY Id INT, DROP PRIMARY KEY, ADD PRIMARY KEY (Id);
LOAD DATA LOCAL INFILE 'PostBlockVersion.csv' INTO TABLE `PostBlockVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostBlockTypeId, PostId, PostHistoryId, LocalId, @PredPostBlockVersionId, @PredPostHistoryId, @PredLocalId, @RootPostBlockVersionId, @RootPostHistoryId, @RootLocalId, @PredEqual, @PredSimilarity, @PredCount, @SuccCount, Length, LineCount, @Content)
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
LOAD DATA LOCAL INFILE 'PostVersionUrl.csv' INTO TABLE `PostVersionUrl`
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
LOAD DATA LOCAL INFILE 'CommentUrl.csv' INTO TABLE `CommentUrl`
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
LOAD DATA LOCAL INFILE 'TitleVersion.csv' INTO TABLE `TitleVersion`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
ESCAPED BY '\"'
LINES TERMINATED BY '\n'
(Id, PostId, PostTypeId, PostHistoryId, PostHistoryTypeId, CreationDate, Title, @PredPostHistoryId, @PredEditDistance, @SuccPostHistoryId, @SuccEditDistance)
SET PredPostHistoryId = nullif(@PredPostHistoryId, ''),
	PredEditDistance = nullif(@PredEditDistance, ''),
	SuccPostHistoryId = nullif(@SuccPostHistoryId, ''),
	SuccEditDistance = nullif(@SuccEditDistance, '');
SET foreign_key_checks = 1;
