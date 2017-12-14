USE `sotorrent17_12`;

SET foreign_key_checks = 0;
DROP TABLE IF EXISTS `PostBlockType`;
DROP TABLE IF EXISTS `PostBlockDiffOperation`;
DROP TABLE IF EXISTS `PostBlockDiff`;
DROP TABLE IF EXISTS `PostVersion`;
DROP TABLE IF EXISTS `PostBlockVersion`;
DROP TABLE IF EXISTS `PostVersionUrl`;
DROP TABLE IF EXISTS `PostReferenceGH`;
SET foreign_key_checks = 1;

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

CREATE TABLE `PostBlockDiff` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostHistoryId INT NOT NULL,
  PredPostBlockVersionId INT NOT NULL,
  PostBlockVersionId INT NOT NULL,
  PostBlockDiffOperationId TINYINT NOT NULL,
  Text TEXT NOT NULL,
  PRIMARY KEY(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PostBlockDiffOperationId) REFERENCES PostBlockDiffOperation(Id)
) AUTO_INCREMENT = 1;

CREATE TABLE `PostVersion` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostHistoryId INT NOT NULL,
  PostTypeId TINYINT NOT NULL,
  PredPostHistoryId INT DEFAULT NULL,
  SuccPostHistoryId INT DEFAULT NULL,
  PRIMARY KEY(Id),
  UNIQUE(PostHistoryId, PredPostHistoryId, SuccPostHistoryId),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PostTypeId) REFERENCES PostType(Id),
  FOREIGN KEY(PredPostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(SuccPostHistoryId) REFERENCES PostHistory(Id)
);

CREATE TABLE `PostBlockVersion` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostVersionId INT DEFAULT NULL,
  PostId INT NOT NULL,
  PostHistoryId INT NOT NULL,
  PostBlockTypeId TINYINT NOT NULL,
  LocalId INT NOT NULL,
  Content TEXT NOT NULL,
  Length INT NOT NULL,
  LineCount INT NOT NULL,
  RootPostBlockId INT DEFAULT NULL,
  PredPostBlockId INT DEFAULT NULL,
  PredEqual BOOLEAN DEFAULT NULL,
  PredSimilarity DOUBLE DEFAULT NULL,
  PredCount INT DEFAULT NULL,
  SuccCount INT DEFAULT NULL,
  PRIMARY KEY(Id),
  UNIQUE(PostHistoryId, PostBlockTypeId, LocalId),
  FOREIGN KEY(PostVersionId) REFERENCES PostVersion(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id),
  FOREIGN KEY(PostBlockTypeId) REFERENCES PostBlockType(Id),
  FOREIGN KEY(RootPostBlockId) REFERENCES PostBlockVersion(Id),
  FOREIGN KEY(PredPostBlockId) REFERENCES PostBlockVersion(Id)
) AUTO_INCREMENT = 1;

ALTER TABLE `PostBlockDiff` ADD FOREIGN KEY(PredPostBlockVersionId) REFERENCES PostBlockVersion(Id);
ALTER TABLE `PostBlockDiff` ADD FOREIGN KEY(PostBlockVersionId) REFERENCES PostBlockVersion(Id);

CREATE TABLE `PostVersionUrl` (
  Id INT NOT NULL AUTO_INCREMENT,
  PostId INT NOT NULL,
  PostHistoryId INT NOT NULL,
  PostBlockVersionId INT NOT NULL,
  Url TEXT,
  PRIMARY KEY(Id),
  FOREIGN KEY(PostId) REFERENCES Posts(Id),
  FOREIGN KEY(PostBlockVersionId) REFERENCES PostBlockVersion(Id),
  FOREIGN KEY(PostHistoryId) REFERENCES PostHistory(Id)
);

CREATE TABLE `PostReferenceGH` (
  FileId VARCHAR(40) NOT NULL,
  RepoName TEXT NOT NULL,
  Branch TEXT NOT NULL,
  Path TEXT NOT NULL,
  FileExt TEXT NOT NULL,
  Size INT NOT NULL,
  PostId INT NOT NULL,
  PostTypeId TINYINT NOT NULL,
  Url TEXT NOT NULL,
  FOREIGN KEY(PostId) REFERENCES Posts(Id)
);
