USE `sotorrent17_12`;

ALTER TABLE `PostBlockDiff` ADD INDEX postblockdiff_index_1 (PredPostBlockVersionId);
ALTER TABLE `PostBlockDiff` ADD INDEX postblockdiff_index_2 (PostBlockVersionId);

ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_1 (LocalId);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_2 (PredSimilarity);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_3 (PredCount);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_4 (SuccCount);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_5 (Length);
ALTER TABLE `PostBlockVersion` ADD INDEX postblockversion_index_6 (LineCount);

ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_1 (FileId);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_2 (RepoName);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_3 (Branch);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_4 (FileExt);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_5 (Size);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_6 (Copies);