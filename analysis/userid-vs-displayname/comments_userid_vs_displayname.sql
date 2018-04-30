SELECT COUNT(*) FROM Comments;
# 62,389,330

SELECT COUNT(*) FROM Comments
WHERE UserId IS NULL AND UserDisplayName IS NULL;
# 591

SELECT COUNT(*) FROM Comments
WHERE UserId IS NOT NULL AND UserDisplayName IS NOT NULL;
# 4,640

SELECT COUNT(*) FROM Comments
WHERE UserId IS NULL XOR UserDisplayName IS NULL;
# 62,384,099

CREATE TABLE CommentsRevised
SELECT * FROM Comments
WHERE UserId IS NULL AND UserDisplayName IS NULL
UNION ALL
SELECT * FROM Comments
WHERE UserId IS NOT NULL AND UserDisplayName IS NOT NULL
UNION ALL
SELECT
	c.Id as Id,
    c.PostId as PostId,
    c.Score as Score,
    c.Text as Text,
    c.CreationDate as CreationDate,
    c.UserDisplayName as UserDisplayName,
    u.Id as UserId
FROM Comments c
LEFT JOIN Users u
ON c.UserDisplayName = u.DisplayName
WHERE UserId IS NULL AND UserDisplayName IS NOT NULL
UNION ALL
SELECT
	c.Id as Id,
    c.PostId as PostId,
    c.Score as Score,
    c.Text as Text,
    c.CreationDate as CreationDate,
    u.DisplayName as UserDisplayName,
    c.UserId as UserId
FROM Comments c
LEFT JOIN Users u
ON c.UserId = u.Id
WHERE UserId IS NOT NULL AND UserDisplayName IS NULL;

SELECT COUNT(*) FROM CommentsRevised;
# 93,865,940

# HYPOTHESIS: DisplayName is not unique

SELECT COUNT(*)
FROM (
	SELECT DisplayName, COUNT(Id) as UserCount
	FROM Users
	GROUP BY DisplayName
	HAVING UserCount>1
) as mult_display;
# 533,378

# VALIDATED

SELECT COUNT(DISTINCT DisplayName) FROM Users;
# 5,765,510


