ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_1 (FileId);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_2 (Repo);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_3 (RepoOwner);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_4 (RepoName);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_5 (Branch);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_6 (FileExt);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_7 (Size);
ALTER TABLE `PostReferenceGH` ADD INDEX postreferencegh_index_8 (Copies);

ALTER TABLE `GHMatches` ADD INDEX ghmatches_index_1 (FileId);

ALTER TABLE `GHCommits` ADD INDEX ghcommits_index_1 (CommitId);
ALTER TABLE `GHCommits` ADD INDEX ghcommits_index_2 (Repo);
ALTER TABLE `GHCommits` ADD INDEX ghcommits_index_3 (RepoOwner);
ALTER TABLE `GHCommits` ADD INDEX ghcommits_index_4 (RepoName);
