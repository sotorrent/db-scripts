
# insert values into type tables (don't use list of values to preserve order)


# PostTypes (see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (1, 'Question');
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (2, 'Answer');
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (3, 'Wiki');
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (4, 'TagWikiExcerpt');
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (5, 'TagWiki');
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (6, 'ModeratorNomination');
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (7, 'WikiPlaceholder');
INSERT INTO `2018_02_16.PostType` (Id, Type) VALUES (8, 'PrivilegeWiki');

# PostBlockTypes
INSERT INTO `2018_02_16.PostBlockType` (Id, Type) VALUES (1, 'TextBlock');
INSERT INTO `2018_02_16.PostBlockType` (Id, Type) VALUES (2, 'CodeBlock');

# PostBlockDiffOperation
INSERT INTO `2018_02_16.PostBlockDiffOperation` (Id, Name) VALUES (-1, 'DELETE');
INSERT INTO `2018_02_16.PostBlockDiffOperation` (Id, Name) VALUES (0, 'EQUAL');
INSERT INTO `2018_02_16.PostBlockDiffOperation` (Id, Name) VALUES (1, 'INSERT');

