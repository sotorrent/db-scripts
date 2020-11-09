
# insert values into type tables (don't use list of values to preserve order)

# PostTypes (see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)
#standardsql
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (1, 'Question');
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (2, 'Answer');
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (3, 'Wiki');
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (4, 'TagWikiExcerpt');
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (5, 'TagWiki');
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (6, 'ModeratorNomination');
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (7, 'WikiPlaceholder');
INSERT INTO `<PROJECT>.<DATASET>.PostType` (Id, Type) VALUES (8, 'PrivilegeWiki');

# PostBlockTypes
#standardsql
INSERT INTO `<PROJECT>.<DATASET>.PostBlockType` (Id, Type) VALUES (1, 'TextBlock');
INSERT INTO `<PROJECT>.<DATASET>.PostBlockType` (Id, Type) VALUES (2, 'CodeBlock');

# PostBlockDiffOperations
#standardsql
INSERT INTO `<PROJECT>.<DATASET>.PostBlockDiffOperation` (Id, Name) VALUES (-1, 'DELETE');
INSERT INTO `<PROJECT>.<DATASET>.PostBlockDiffOperation` (Id, Name) VALUES (0, 'EQUAL');
INSERT INTO `<PROJECT>.<DATASET>.PostBlockDiffOperation` (Id, Name) VALUES (1, 'INSERT');

# PostHistoryTypes (see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)
#standardsql
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (1, 'Initial Title');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (2, 'Initial Body');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (3, 'Initial Tags');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (4, 'Edit Title');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (5, 'Edit Body');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (6, 'Edit Tags');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (7, 'Rollback Title');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (8, 'Rollback Body');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (9, 'Rollback Tags');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (10, 'Post Closed');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (11, 'Post Reopened');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (12, 'Post Deleted');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (12, 'Post Deleted');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (13, 'Post Undeleted');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (14, 'Post Locked');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (15, 'Post Unlocked');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (16, 'Community Owned');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (17, 'Post Migrated');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (18, 'Question Merged');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (19, 'Question Protected');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (20, 'Question Unprotected');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (22, 'Question Unmerged');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (24, 'Suggested Edit Applied');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (25, 'Post Tweeted');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (31, 'Discussion moved to chat');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (33, 'Post Notice Added');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (34, 'Post Notice Removed');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (35, 'Post Migrated Away');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (36, 'Post Migrated Here');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (37, 'Post Merge Source');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (38, 'Post Merge Destination');
INSERT INTO `<PROJECT>.<DATASET>.PostHistoryType` (Id, Type) VALUES (50, 'CommunityBump');

# VoteTypes (see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)
#standardsql
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (1, 'AcceptedByOriginator');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (2, 'UpMod');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (3, 'DownMod');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (4, 'Offensive');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (5, 'Favorite');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (6, 'Close');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (7, 'Reopen');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (8, 'BountyStart');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (9, 'BountyClose');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (10, 'Deletion');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (11, 'Undeletion');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (12, 'Spam');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (15, 'ModeratorReview');
INSERT INTO `<PROJECT>.<DATASET>.VoteType` (Id, Type) VALUES (16, 'ApproveEditSuggestion');
