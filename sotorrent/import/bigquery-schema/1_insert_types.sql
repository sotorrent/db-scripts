
# insert values into type tables (don't use list of values to preserve order)

# PostTypes (see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)
#standardsql
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (1, 'Question');
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (2, 'Answer');
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (3, 'Wiki');
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (4, 'TagWikiExcerpt');
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (5, 'TagWiki');
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (6, 'ModeratorNomination');
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (7, 'WikiPlaceholder');
INSERT INTO `sotorrent-org.2019_06_21.PostType` (Id, Type) VALUES (8, 'PrivilegeWiki');

# PostBlockTypes
#standardsql
INSERT INTO `sotorrent-org.2019_06_21.PostBlockType` (Id, Type) VALUES (1, 'TextBlock');
INSERT INTO `sotorrent-org.2019_06_21.PostBlockType` (Id, Type) VALUES (2, 'CodeBlock');

# PostBlockDiffOperations
#standardsql
INSERT INTO `sotorrent-org.2019_06_21.PostBlockDiffOperation` (Id, Name) VALUES (-1, 'DELETE');
INSERT INTO `sotorrent-org.2019_06_21.PostBlockDiffOperation` (Id, Name) VALUES (0, 'EQUAL');
INSERT INTO `sotorrent-org.2019_06_21.PostBlockDiffOperation` (Id, Name) VALUES (1, 'INSERT');

# PostHistoryTypes (see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)
#standardsql
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (1, 'Initial Title');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (2, 'Initial Body');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (3, 'Initial Tags');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (4, 'Edit Title');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (5, 'Edit Body');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (6, 'Edit Tags');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (7, 'Rollback Title');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (8, 'Rollback Body');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (9, 'Rollback Tags');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (10, 'Post Closed');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (11, 'Post Reopened');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (12, 'Post Deleted');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (12, 'Post Deleted');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (13, 'Post Undeleted');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (14, 'Post Locked');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (15, 'Post Unlocked');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (16, 'Community Owned');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (17, 'Post Migrated');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (18, 'Question Merged');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (19, 'Question Protected');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (20, 'Question Unprotected');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (22, 'Question Unmerged');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (24, 'Suggested Edit Applied');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (25, 'Post Tweeted');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (31, 'Discussion moved to chat');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (33, 'Post Notice Added');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (34, 'Post Notice Removed');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (35, 'Post Migrated Away');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (36, 'Post Migrated Here');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (37, 'Post Merge Source');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (38, 'Post Merge Destination');
INSERT INTO `sotorrent-org.2019_06_21.PostHistoryType` (Id, Type) VALUES (50, 'CommunityBump');

# VoteTypes (see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)
#standardsql
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (1, 'AcceptedByOriginator');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (2, 'UpMod');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (3, 'DownMod');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (4, 'Offensive');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (5, 'Favorite');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (6, 'Close');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (7, 'Reopen');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (8, 'BountyStart');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (9, 'BountyClose');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (10, 'Deletion');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (11, 'Undeletion');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (12, 'Spam');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (15, 'ModeratorReview');
INSERT INTO `sotorrent-org.2019_06_21.VoteType` (Id, Type) VALUES (16, 'ApproveEditSuggestion');
