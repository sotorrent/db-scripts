SET foreign_key_checks = 0;
DROP TABLE IF EXISTS `PostBlockType`;
DROP TABLE IF EXISTS `PostBlockDiffOperation`;
DROP TABLE IF EXISTS `PostBlockDiff`;
DROP TABLE IF EXISTS `PostVersion`;
DROP TABLE IF EXISTS `PostBlockVersion`;
DROP TABLE IF EXISTS `PostVersionUrl`;
DROP TABLE IF EXISTS `CommentUrl`;
DROP TABLE IF EXISTS `PostReferenceGH`;
DROP TABLE IF EXISTS `TitleVersion`;
DROP TABLE IF EXISTS `GHMatches`;
DROP TABLE IF EXISTS `StackSnippetVersion`;
SET foreign_key_checks = 1;


######################
# Create type tables #
######################

CREATE TABLE `PostBlockType` (
  Id TINYINT NOT NULL,
  Type VARCHAR(50) NOT NULL,
  PRIMARY KEY(Id)
);

INSERT INTO `PostBlockType` VALUES(1, 'TextBlock');
INSERT INTO `PostBlockType` VALUES(2, 'CodeBlock');

CREATE TABLE `PostBlockDiffOperation` (
  Id TINYINT NOT NULL,
  Name VARCHAR(50) NOT NULL,
  PRIMARY KEY(Id)
);

INSERT INTO `PostBlockDiffOperation` VALUES(-1, 'DELETE');
INSERT INTO `PostBlockDiffOperation` VALUES(0, 'EQUAL');
INSERT INTO `PostBlockDiffOperation` VALUES(1, 'INSERT');


######################
# Create data tables #
######################

CREATE TABLE `PostBlockDiff` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostHistoryId INT NOT NULL,
  LocalId INT NOT NULL,
  PostBlockVersionId INT NOT NULL,
  PredPostHistoryId INT NOT NULL,
  PredLocalId INT NOT NULL,
  PredPostBlockVersionId INT NOT NULL,
  PostBlockDiffOperationId TINYINT NOT NULL,
  Text TEXT NOT NULL,
  PRIMARY KEY(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PredPostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PostBlockDiffOperationId) REFERENCES PostBlockDiffOperation(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `PostVersion` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostTypeId TINYINT NOT NULL,
  PostHistoryId INT NOT NULL,
  PostHistoryTypeId TINYINT NOT NULL,
  CreationDate DATETIME NOT NULL,
  PredPostHistoryId INT DEFAULT NULL,
  SuccPostHistoryId INT DEFAULT NULL,
  MostRecentVersion BOOLEAN DEFAULT FALSE,
  PRIMARY KEY(Id),
  UNIQUE(PostHistoryId, PredPostHistoryId, SuccPostHistoryId),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PostTypeId) REFERENCES PostType(Id),
  FOREIGN KEY(PostHistoryTypeId) REFERENCES PostHistoryType(Id),
  FOREIGN KEY(PredPostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(SuccPostHistoryId) REFERENCES PostHistory(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `PostBlockVersion` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostBlockTypeId TINYINT NOT NULL,
  PostId INT NOT NULL,
  PostHistoryId INT NOT NULL,
  LocalId INT NOT NULL,
  PredPostBlockVersionId INT DEFAULT NULL,
  PredPostHistoryId INT DEFAULT NULL,
  PredLocalId INT DEFAULT NULL,
  RootPostBlockVersionId INT DEFAULT NULL,
  RootPostHistoryId INT DEFAULT NULL,
  RootLocalId INT DEFAULT NULL,
  PredEqual BOOLEAN DEFAULT NULL,
  PredSimilarity DOUBLE DEFAULT NULL,
  PredCount INT DEFAULT NULL,
  SuccCount INT DEFAULT NULL,
  Length INT NOT NULL,
  LineCount INT NOT NULL,
  Content TEXT NOT NULL,
  MostRecentVersion BOOLEAN DEFAULT FALSE,
  PRIMARY KEY(Id),
  UNIQUE(PostHistoryId, PostBlockTypeId, LocalId),
  FOREIGN KEY(PostBlockTypeId) REFERENCES PostBlockType(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PredPostBlockVersionId) REFERENCES PostBlockVersion(Id),
  FOREIGN KEY(PredPostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(RootPostBlockVersionId) REFERENCES PostBlockVersion(Id),
  FOREIGN KEY(RootPostHistoryId) REFERENCES PostHistory(Id)
) AUTO_INCREMENT = 1;

ALTER TABLE `PostBlockDiff` ADD FOREIGN KEY(PostBlockVersionId) REFERENCES PostBlockVersion(Id);
ALTER TABLE `PostBlockDiff` ADD FOREIGN KEY(PredPostBlockVersionId) REFERENCES PostBlockVersion(Id);

CREATE TABLE `PostVersionUrl` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostHistoryId INT NOT NULL,
  PostBlockVersionId INT NOT NULL,
  LinkType VARCHAR(32) NOT NULL,
  LinkPosition VARCHAR(32) NOT NULL,
  LinkAnchor TEXT DEFAULT NULL,
  Protocol TEXT NOT NULL,
  RootDomain TEXT NOT NULL,
  CompleteDomain TEXT NOT NULL,
  Path TEXT DEFAULT NULL,
  Query TEXT DEFAULT NULL,
  FragmentIdentifier TEXT DEFAULT NULL,
  Url TEXT NOT NULL,
  FullMatch TEXT NOT NULL,
  PRIMARY KEY(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PostBlockVersionId) REFERENCES PostBlockVersion(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `CommentUrl` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  CommentId INT NOT NULL,
  LinkType VARCHAR(32) NOT NULL,
  LinkPosition VARCHAR(32) NOT NULL,
  LinkAnchor TEXT DEFAULT NULL,
  Protocol TEXT NOT NULL,
  RootDomain TEXT NOT NULL,
  CompleteDomain TEXT NOT NULL,
  Path TEXT DEFAULT NULL,
  Query TEXT DEFAULT NULL,
  FragmentIdentifier TEXT DEFAULT NULL,
  Url TEXT NOT NULL,
  FullMatch TEXT NOT NULL,
  PRIMARY KEY(Id),
  # the SO data dump contains comments for posts that don't exist anymore
  # FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(CommentId) REFERENCES Comments(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `PostReferenceGH` (
  Id INT NOT NULL AUTO_INCREMENT,
  FileId VARCHAR(40) NOT NULL,
  Repo VARCHAR(255) NOT NULL,
  RepoOwner VARCHAR(255) NOT NULL,
  RepoName VARCHAR(255) NOT NULL,
  Branch VARCHAR(255) NOT NULL,
  Path TEXT NOT NULL,
  FileExt VARCHAR(255) NOT NULL,
  Size INT NOT NULL,
  Copies INT NOT NULL,
  PostId INT NOT NULL,
  CommentId INT DEFAULT NULL,
  SOUrl TEXT NOT NULL,
  GHUrl TEXT NOT NULL,
  PRIMARY KEY(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(CommentId) REFERENCES Comments(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `TitleVersion` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostTypeId TINYINT NOT NULL,
  PostHistoryId INT NOT NULL,
  PostHistoryTypeId TINYINT NOT NULL,
  CreationDate DATETIME NOT NULL,
  Title TEXT NOT NULL,
  PredPostHistoryId INT DEFAULT NULL,
  PredEditDistance INT DEFAULT NULL,
  SuccPostHistoryId INT DEFAULT NULL,
  SuccEditDistance INT DEFAULT NULL,
  MostRecentVersion BOOLEAN DEFAULT FALSE,
  PRIMARY KEY(Id),
  UNIQUE(PostHistoryId, PredPostHistoryId, SuccPostHistoryId),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostTypeId) REFERENCES PostType(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PostHistoryTypeId) REFERENCES PostHistoryType(Id),
  FOREIGN KEY(PredPostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(SuccPostHistoryId) REFERENCES PostHistory(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `GHMatches` (
  Id INT NOT NULL AUTO_INCREMENT,
  FileId VARCHAR(40) NOT NULL,
  PostIds TEXT NOT NULL,
  MatchedLine LONGTEXT NOT NULL,
  PRIMARY KEY(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `StackSnippetVersion` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostTypeId TINYINT NOT NULL,
  PostHistoryId INT NOT NULL,
  Content TEXT NOT NULL,
  PRIMARY KEY(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostTypeId) REFERENCES PostType(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id)
) AUTO_INCREMENT = 1;