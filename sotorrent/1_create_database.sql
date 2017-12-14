# Copyright (c) 2013 Georgios Gousios
# MIT-licensed
# Updated by Sebastian Baltes to support December 2017 data set

# collation: http://stackoverflow.com/a/1036459/1974143
# character set: http://stackoverflow.com/a/20429481/1974143 and https://mathiasbynens.be/notes/mysql-utf8mb4#character-sets
# underscore vs. camel case: http://stackoverflow.com/a/14319048/1974143
# types: http://dev.mysql.com/doc/workbench/en/wb-migration-database-mssql-typemapping.html

DROP DATABASE IF EXISTS `sotorrent17_12`;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE `sotorrent17_12` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

USE `sotorrent17_12`;

CREATE TABLE `Users` (
    Id INT NOT NULL,
    Reputation INT NOT NULL,
    CreationDate DATETIME,
    DisplayName VARCHAR(40),
    LastAccessDate DATETIME,
    WebsiteUrl VARCHAR(200),
    Location VARCHAR(100),
    ProfileImageUrl VARCHAR(200),
    AboutMe TEXT,
    Views INT DEFAULT 0,
    UpVotes INT,
    DownVotes INT,
    Age INT,
    AccountId INT,
    EmailHash VARCHAR(32),
    PRIMARY KEY (Id)
);

CREATE TABLE `Badges` (
    Id INT NOT NULL,
    UserId INT NOT NULL,
    Name VARCHAR(50),
    Date DATETIME,
    Class TINYINT,
    TagBased TINYINT(1),
    PRIMARY KEY (Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE `Posts` (
    Id INT NOT NULL,
    PostTypeId TINYINT,
    AcceptedAnswerId INT,
    ParentId INT,
    CreationDate DATETIME,
    DeletionDate DATETIME,
    Score INT,
    ViewCount INT,
    Body TEXT,
    OwnerUserId INT, # either OwnerUserId or OwnerDisplayName (or both) are present
    OwnerDisplayName VARCHAR(40),
    LastEditorUserId INT,
    LastEditorDisplayName VARCHAR(40),
    LastEditDate DATETIME,
    LastActivityDate DATETIME,
    Title VARCHAR(250),
    Tags VARCHAR(150),
    AnswerCount INT DEFAULT 0,
    CommentCount INT DEFAULT 0,
    FavoriteCount INT DEFAULT 0,
    ClosedDate DATETIME,
    CommunityOwnedDate DATETIME,
    PRIMARY KEY (Id),
    FOREIGN KEY (AcceptedAnswerId) REFERENCES Posts(Id),
    FOREIGN KEY (ParentId) REFERENCES Posts(Id)
);

CREATE TABLE `Comments` (
    Id INT NOT NULL,
    PostId INT NOT NULL,
    Score INT NOT NULL DEFAULT 0,
    Text TEXT,
    CreationDate DATETIME,
    UserDisplayName VARCHAR(30),
    UserId INT, # either UserId or UserDisplayName is present
    PRIMARY KEY (Id),
    FOREIGN KEY (PostId) REFERENCES Posts(Id)
);

CREATE TABLE `PostHistory` (
    Id INT NOT NULL,
    PostHistoryTypeId TINYINT NOT NULL,
    PostId INT NOT NULL,
    RevisionGUID VARCHAR(64),
    CreationDate DATETIME,
    UserId INT, # either UserId or UserDisplayName is present
    UserDisplayName VARCHAR(40),
    Comment TEXT,
    Text MEDIUMTEXT,
    PRIMARY KEY (Id),
    FOREIGN KEY (PostId) REFERENCES Posts(Id)
);

CREATE TABLE `PostLinks` (
    Id INT NOT NULL,
    CreationDate DATETIME,
    PostId INT NOT NULL,
    RelatedPostId INT NOT NULL,
    LinkTypeId TINYINT,
    PRIMARY KEY (Id),
    FOREIGN KEY (PostId) REFERENCES Posts(Id),
    FOREIGN KEY (RelatedPostId) REFERENCES Posts(Id)
);

CREATE TABLE `Tags` (
    Id INT NOT NULL,
    TagName VARCHAR(25),
    Count INT,
    ExcerptPostId INT,
    WikiPostId INT,
    PRIMARY KEY(Id)
);

CREATE TABLE `Votes` (
    Id INT NOT NULL,
    PostId INT NOT NULL,
    VoteTypeId TINYINT,
    UserId INT,
    CreationDate DATETIME,
    BountyAmount INT,
    PRIMARY KEY (Id),
    FOREIGN KEY (PostId) REFERENCES Posts(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

# see https://meta.stackexchange.com/a/2678
CREATE TABLE `PostType` (
  Id TINYINT NOT NULL,
  Type VARCHAR(50) NOT NULL,
  PRIMARY KEY(Id)
);

# see http://data.stackexchange.com/stackoverflow/query/36599/show-all-types
INSERT INTO `PostType` VALUES(1, 'Question');
INSERT INTO `PostType` VALUES(2, 'Answer');
INSERT INTO `PostType` VALUES(3, 'Wiki');
INSERT INTO `PostType` VALUES(4, 'TagWikiExcerpt');
INSERT INTO `PostType` VALUES(5, 'TagWiki');
INSERT INTO `PostType` VALUES(6, 'ModeratorNomination');
INSERT INTO `PostType` VALUES(7, 'WikiPlaceholder');
INSERT INTO `PostType` VALUES(8, 'PrivilegeWiki');

ALTER TABLE `Posts` ADD FOREIGN KEY(PostTypeId) REFERENCES PostType(Id);
