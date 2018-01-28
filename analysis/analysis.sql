##########
# get java posts (to compare all vs. java posts)
##########
select Id as PostId, PostTypeId
from Posts
where PostTypeId = 1 and Tags like '%<java>%'
into outfile '/data/tmp/java_questions.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select Id as PostId, a.PostTypeId as PostTypeId
from (
  select Id as PostId, PostTypeId
  from Posts
  where PostTypeId = 1 and Tags like '%<java>%'
) q
join Posts a
on q.PostId = a.ParentId
where a.PostTypeId = 2
into outfile '/data/tmp/java_answers.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# analyze post scores
##########
select Id as PostId, PostTypeId, Score
from Posts
where PostTypeId in (1, 2)
into outfile '/data/tmp/posts_score.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';



##########
# number of text/code blocks per post
##########
select
  p2.PostId as PostId,
  p2.PostTypeId as PostTypeId,
  VersionCount,
  FirstPostHistoryId,
  LastPostHistoryId
from (
  select
    p.PostId as PostId,
    p.PostTypeId as PostTypeId,
    VersionCount,
    FirstPostHistoryId
  from (
    select PostId, PostTypeId, count(Id) as VersionCount
    from PostVersion
    group by PostId, PostTypeId
  ) p
  join (
    select PostId, min(PostHistoryId) as FirstPostHistoryId
    from PostVersion
    group by PostId
  ) p_first
  on p.PostId = p_first.PostId
) p2
join (
  select PostId, max(PostHistoryId) as LastPostHistoryId
  from PostVersion
  group by PostId
) p_last
on p2.PostId = p_last.PostId
into outfile '/data/tmp/posts_versioncount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostId, PostHistoryId, count(Id) as TextBlockCount
from PostBlockVersion
where PostBlockTypeId=1
group by PostId, PostHistoryId
into outfile '/data/tmp/posts_textblockcount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostId, PostHistoryId, count(Id) as CodeBlockCount
from PostBlockVersion
where PostBlockTypeId=2
group by PostId, PostHistoryId
into outfile '/data/tmp/posts_codeblockcount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##################################################
# correlations
##################################################

##########
# is code in upvoted posts changed more often?
##########
##########
# is code in posts with many commentes changed more often?
##########
##########
# is code in old posts changed more often?
##########
select
  Id as PostId,
  PostTypeId,
  Score,
  CommentCount,
  TIMESTAMPDIFF(DAY, CreationDate, "2017-12-31 23:59:00") as Age,
  OwnerUserId
from Posts
WHERE PostTypeId in (1, 2)
into outfile '/data/tmp/posts_metadata.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# are code snippets found on GH more likely to be revised?
##########
select PostId, count(FileId) as GHMatchCount
from PostReferenceGH
group by PostId
into outfile '/data/tmp/posts_gh-matches.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# does author reputation influence the versioncount?
##########
select Id as UserId, Reputation
from Users
into outfile '/data/tmp/users_reputation.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


# compare everything with versioncount

##################################################



##########
# length of all text block lifespans
##########
select pbv.PostId as PostId, PostTypeId, RootPostBlockId, count(pbv.Id) as LifespanLength
from PostBlockVersion pbv
left join PostVersion pv
on pbv.PostId = pv.PostId
where PostBlockTypeId=1 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostTypeId, RootPostBlockId
into outfile '/data/tmp/textblock_lifespan_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# length of all code block lifespans
##########
select pbv.PostId as PostId, PostTypeId, RootPostBlockId, count(pbv.Id) as LifespanLength
from PostBlockVersion pbv
left join PostVersion pv
on pbv.PostId = pv.PostId
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostTypeId, RootPostBlockId
into outfile '/data/tmp/codeblock_lifespan_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';



# are text and code blocks changed together?
select PostId, PostHistoryId, Count(Id) as TextBlockEdits
from PostBlockVersion
where PostBlockTypeId=1 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostHistoryId
into outfile '/data/tmp/textblock_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostId, PostHistoryId, Count(Id) as TextBlockEdits
from PostBlockVersion
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostHistoryId
into outfile '/data/tmp/codeblock_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';



# length of text blocks
select PostId, PostHistoryId, Id as PostBlockVersionId, Length, LineCount
from PostBlockVersion
where PostBlockTypeId=1
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile '/data/tmp/textblock_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

# length of code blocks
select PostId, PostHistoryId, Id as PostBlockVersionId, Length, LineCount
from PostBlockVersion
where PostBlockTypeId=2
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile '/data/tmp/codeblock_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

# length of text blocks over time (only consider changes)
select PostId, RootPostBlockId, Id as PostBlockVersionId, Length, LineCount
from PostBlockVersion
where PostBlockTypeId=1 and (PredEqual IS NULL or PredEqual=0)
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile '/data/tmp/textblock_length_over_time.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

# length of code blocks over time (only consider changes)
select PostId, RootPostBlockId, Id as PostBlockVersionId, Length, LineCount
from PostBlockVersion
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0)
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile '/data/tmp/codeblock_length_over_time.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


# analyze who edited the posts
select
  PostId,
  PostTypeId,
  OwnerUserId,
  PostHistoryId,
  PostHistoryTypeId,
  PostHistoryCreationDate,
  UserId,
  UserCreationDate,
  UserReputation
from (
  select
    PostId,
    ph.Id as PostHistoryId,
    PostHistoryTypeId,
    ph.CreationDate as PostHistoryCreationDate,
    UserId,
    u.CreationDate as UserCreationDate,
    Reputation as UserReputation
  from PostHistory ph
  left join Users u
  on ph.UserId = u.Id
  where PostHistoryTypeId in (2, 5, 8)
) ph_u
left join Posts p
on ph_u.PostId = p.Id
where PostTypeId in (1, 2)
into outfile '/data/tmp/posthistory_users.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


# analyze timespan between the edits
select
  pv1.PostId as PostId,
  pv1.PostTypeId as PostTypeId,
  pv1.PostHistoryId as PostHistoryId,
  pv1.PostHistoryTypeId as PostHistoryTypeId,
  pv1.CreationDate as CreationDate,
  pv1.SuccPostHistoryId as SuccPostHistoryId,
  ph1.PostHistoryTypeId as SuccPostHistoryTypeId,
  ph1.CreationDate as SuccCreationDate,
  TIMESTAMPDIFF(DAY, pv1.CreationDate, ph1.CreationDate) as SuccCreationDateDiff
from (
  select
    pv.PostId as PostId,
    PostTypeId,
    PostHistoryId,
    PostHistoryTypeId,
    CreationDate,
    SuccPostHistoryId
  from PostVersion pv
  join PostHistory ph
  on pv.PostHistoryId = ph.Id
) pv1
left join PostHistory ph1
on SuccPostHistoryId = Id
into outfile '/data/tmp/postversion_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


# retrieve lines deleted/added
select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, count(PostBlockDiffOperationId) as LinesDeleted
from PostBlockDiff
where PostBlockDiffOperationId=-1
group by PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId
into outfile '/data/tmp/postblockversion_linesdeleted.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, count(PostBlockDiffOperationId) as LinesAdded
from PostBlockDiff
where PostBlockDiffOperationId=1
group by PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId
into outfile '/data/tmp/postblockversion_linesadded.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select Id as PostBlockVersionId, PostBlockTypeId
from PostBlockVersion
group by PostBlockVersionId, PostBlockTypeId
into outfile '/data/tmp/postblockversion_type.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

