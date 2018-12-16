USE `sotorrent18_12`;

ALTER TABLE `PostBlockDiff` ADD INDEX postblockdiff_index_1 (LocalId);
ALTER TABLE `PostBlockDiff` ADD INDEX postblockdiff_index_2 (PredLocalId);

ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_1 (LocalId);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_2 (PredLocalId);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_3 (RootLocalId);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_4 (PredSimilarity);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_5 (PredCount);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_6 (SuccCount);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_7 (Length);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_8 (LineCount);

ALTER TABLE `CommentUrl` ADD INDEX commenturl_index_1 (PostId);

ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_1 (FileId);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_2 (RepoName);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_3 (Branch);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_4 (FileExt);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_5 (Size);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_6 (Copies);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_7 (CommentId);

ALTER TABLE `TitleVersion` ADD INDEX titleversion_index_1 (PredEditDistance);
ALTER TABLE `TitleVersion` ADD INDEX titleversion_index_2 (SuccEditDistance);

ALTER TABLE `GHMatches` ADD INDEX ghmatches_index_1 (FileId);
