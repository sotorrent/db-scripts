-- retrieve Java method signatures from SO posts tagged <java> and/or <android>

#standardsql
WITH
	JavaThreads AS (
		SELECT PostId, ParentId
		FROM `sotorrent-org.2019_06_21.Threads`
		WHERE ParentId IN (
			SELECT Id
			FROM `sotorrent-org.2019_06_21.Posts`
			WHERE PostTypeId = 1 
		  	AND REGEXP_CONTAINS(Tags, r'(<java>|<android>)')
		)
	),
	JavaMethods AS (
		SELECT
			PostId,
			ParentId,
			PostHistoryId,
			LocalId,
			ARRAY_LENGTH(Lines) AS LineCount,
			MethodCount,
			MethodSignatures,
			ARRAY_TO_STRING(Lines, '\n') AS Content
		FROM (
			SELECT
				PostId,
				ParentId,
				PostHistoryId,
				LocalId,
		    MethodCount,
				MethodSignatures,
				ARRAY(
					SELECT Line
					FROM UNNEST(Lines) AS Line
			    WHERE LENGTH(TRIM(Line)) > 0 --- remove empty lines
				) as Lines
			FROM (
				SELECT
					PostId,
					ParentId,
					PostHistoryId,
					LocalId,
					ARRAY_LENGTH(MethodSignatures) AS MethodCount,
					REGEXP_REPLACE(ARRAY_TO_STRING(MethodSignatures, ' | '), r'\s+', ' ') AS MethodSignatures, --- normalize whitespaces in method signatures
					SPLIT(Content, '\n') AS Lines
				FROM (
					SELECT
						PostId,
						ParentId,
						PostHistoryId,
						LocalId,
						REGEXP_EXTRACT_ALL(Content, r'((?:(?:public|private|protected|static|final|native|synchronized|abstract|transient)+\s+)+[$_\w<>\[\]\s]*\s+[\$_\w]+\([^\)]*\)?)\s*\{') AS MethodSignatures,
						Content
					FROM (
					  SELECT
					  	pbv.PostId AS PostId,
					  	ParentId,
					  	PostHistoryId,
					  	LocalId,
					  	REGEXP_REPLACE(Content, r'&#xD;&#xA;', '\n') AS Content
					  FROM `sotorrent-org.2019_06_21.PostBlockVersion` pbv
					  JOIN JavaThreads jt
					  ON pbv.PostId = jt.PostId			  
					  WHERE PostBlockTypeId = 2 AND MostRecentVersion = TRUE
					)
					WHERE REGEXP_CONTAINS(Content, r'((?:(?:public|private|protected|static|final|native|synchronized|abstract|transient)+\s+)+[$_\w<>\[\]\s]*\s+[\$_\w]+\([^\)]*\)?)\s*\{')
				)
			)
		)
	)
SELECT
	PostId,
	ParentId,
	PostHistoryId,
	LocalId,
	LineCount,
	ARRAY_LENGTH(ClassDeclarations) AS ClassCount,
	MethodCount,
  REGEXP_REPLACE(ARRAY_TO_STRING(ClassDeclarations, ' | '), r'\s+', ' ') AS ClassDeclarations, --- normalize whitespaces in class declarations
	MethodSignatures,
	Content
FROM (
	SELECT
		PostId,
		ParentId,
		PostHistoryId,
		LocalId,
		LineCount,
		MethodCount,
		MethodSignatures,
		REGEXP_EXTRACT_ALL(Content, r'((?:(?:public|private|protected|static|final|native|synchronized|abstract|transient)+\s+)*(?:class|interface)\s+[$_\w<>\[\]]+)') AS ClassDeclarations,
		Content
	FROM JavaMethods
);

=> so-tests.2019_06_21.JavaMethodsAndClasses


--- select Java methods mutually referenced between SO Posts and GH files

#standardsql
SELECT 
	methodsclasses.ParentId AS ParentId,
	methodsclasses.PostId AS PostId,
	LocalId,
	PostHistoryId,
	methodsclasses.LineCount AS SOLineCount,
	methodsclasses.ClassCount AS SOClassCount,
	methodsclasses.MethodCount AS SOMethodCount,
	references.Repo AS GHRepo,
	references.FileExt AS GHFileExt,
  	SOUrl,
  	GHUrl,
  	methodsclasses.ClassDeclarations AS SOClassDeclarations,
	methodsclasses.MethodSignatures AS SOMethodSignatures,
	references.FileId AS GHFileId,
	methodsclasses.Content AS SOContent
FROM `so-tests.2019_06_21.JavaMethodsAndClasses` methodsclasses
JOIN `so-tests.2019_06_21.MutualReferences` references
ON methodsclasses.PostId = references.PostId
ORDER BY ParentId, PostId, LocalId;

=> so-tests.2019_06_21.JavaMethodsAndClassesMutualReference
