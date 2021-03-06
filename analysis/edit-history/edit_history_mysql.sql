USE sotorrent18_09;


# create table with edit history of posts (title and body edits, comments)
CREATE TABLE EditHistory AS
SELECT *
FROM (
	SELECT
	  pv.PostId as PostId,
	  pv.PostTypeId as PostTypeId,
	  PostHistoryId as EventId,
	  CASE
		WHEN pv.PostHistoryTypeId=2 THEN "InitialBody"
		ELSE "BodyEdit"
	  END as Event,
	  UserId,
	  pv.CreationDate AS CreationDate
	FROM PostVersion pv
	JOIN PostHistory ph
	ON pv.PostHistoryId = ph.Id
	UNION ALL
	SELECT
	  tv.PostId as PostId,
	  tv.PostTypeId as PostTypeId,
	  PostHistoryId as EventId,
	  CASE
		WHEN tv.PostHistoryTypeId=1 THEN "InitialTitle"
		ELSE "TitleEdit"
	  END as Event,
	  UserId,
	  tv.CreationDate as CreationDate
	FROM TitleVersion tv
	JOIN PostHistory ph
	ON tv.PostHistoryId = ph.Id
	UNION ALL
	SELECT
	  PostId,
	  PostTypeId,
	  c.Id as EventId,
	  "Comment" AS Event,
	  UserId,
	  c.CreationDate as CreationDate
	FROM Comments c
	JOIN Posts p
	ON c.PostId = p.Id
) AS EditHistory;
ALTER TABLE EditHistory ADD INDEX EditHistoryPostIdIndex (PostId);
ALTER TABLE EditHistory ADD INDEX EditHistoryEventIdIndex (EventId);

# query to retrieve edit history of a thread using the post id of a question or an answer
SELECT *
FROM EditHistory
WHERE PostId IN (
	SELECT PostId
	FROM Threads
	WHERE ParentId = (
	  SELECT ParentID
	  FROM Threads
	  WHERE PostId=3758880 # this is an answer id, the question id 3758606 yields the same result
	)
)
ORDER BY CreationDate;
