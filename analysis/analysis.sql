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


   
##########
# order of post blocks
##########
select p1.Id as PostBlockVersionId, (p2.LocalId - p1.LocalId) as LocalIdDiff
from PostBlockVersion p1
join PostBlockVersion p2
on p1.PredPostBlockId = p2.Id
into outfile '/data/tmp/postblockversion_localiddiff.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';



# compare edit and comment/vote dates
select
  PostId,
  Date,
  Count(PostHistoryId) as EditCount
from (
  select
    PostId,
    date(CreationDate) as Date,
    Id as PostHistoryId
  from PostHistory
  where PostHistoryTypeId in (2, 5, 8)
) edits
group by PostId, Date
into outfile '/data/tmp/posthistory_date_editcount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select
  PostId,
  Date,
  Count(CommentId) as CommentCount
from (
  select
    PostId,
    date(CreationDate) as Date,
    Id as CommentId
  from Comments
) comments
group by PostId, Date
into outfile '/data/tmp/comments_date_commentcount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


# analyze connection of edits and votes
select
  PostId,
  Date,
  SUM(UpVote) as UpVotes,
  SUM(DownVote) as DownVotes
from (
  select
    PostId,
    date(CreationDate) as Date,
    Id as VoteId,
    case VoteTypeId
      when 2 then 1
      else NULL
    end as UpVote,
    case VoteTypeId
      when 3 then 1
      else NULL
    end as DownVote
  from Votes
  where VoteTypeId in (2, 3) # (upvote, downvote)
) votes
group by PostId, Date
into outfile '/data/tmp/votes_date_votecount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';




# analyze edits and comments happening on the same day

create table edits_comments as
select
  edits_aggregated.PostId as PostId,
  edits_aggregated.Date as Date,
  EditCount,
  CommentCount
from (
  select
    PostId,
    Date,
    Count(PostHistoryId) as EditCount
  from (
    select
      PostId,
      date(CreationDate) as Date,
      Id as PostHistoryId
    from PostHistory
    where PostHistoryTypeId in (2, 5, 8)
  ) edits
  group by PostId, Date
) edits_aggregated
join (
  select
    PostId,
    Date,
    Count(CommentId) as CommentCount
  from (
    select
      PostId,
      date(CreationDate) as Date,
      Id as CommentId
    from Comments
  ) comments
  group by PostId, Date
) comments_aggregated
on edits_aggregated.PostId = comments_aggregated.PostId
  and edits_aggregated.Date = comments_aggregated.Date;

  
create table edits_comments_2 as
select
  post_dates.PostId as PostId,
  post_dates.Date as Date,
  CommentId,
  CommentTimestamp
from (
  select PostId, Date
  from edits_comments
  where EditCount>0 & CommentCount>0
) post_dates
join (
  select
    PostId,
    date(CreationDate) as Date,
    CreationDate as CommentTimestamp,
    Id as CommentId
  from Comments
) comments
on post_dates.PostId = comments.PostId
  and post_dates.Date = comments.Date;


drop table edits_comments;

create table edits_comments as
select
  edits_comments.PostId as PostId,
  edits_comments.Date as Date,
  CommentId,
  CommentTimestamp,
  PostHistoryId,
  EditTimestamp,
  TIMESTAMPDIFF(SECOND, EditTimestamp, CommentTimestamp) as TimestampDiff
from edits_comments_2 edits_comments
join (
  select
    PostId,
    date(CreationDate) as Date,
    CreationDate as EditTimestamp,
    Id as PostHistoryId
  from PostHistory
  where PostHistoryTypeId in (2, 5, 8)
) ph
on edits_comments.PostId = ph.PostId
  and edits_comments.Date = ph.Date;

drop table edits_comments_2;

create table edits_comments_min as
select
  PostHistoryId,
  CommentId,
  min(abs(TimestampDiff)) as MinTimestampDiffAbs
from edits_comments
group by PostHistoryId, CommentId;

create table edits_comments_filtered as
select
  PostHistoryId,
  CommentId,
  TimestampDiff
from edits_comments;

drop table edits_comments;

# cannot create indices because SSD is full

#CREATE INDEX edits_comments_min_index_1 ON edits_comments_min(PostHistoryId);
#CREATE INDEX edits_comments_min_index_2 ON edits_comments_min(CommentId);
#CREATE INDEX edits_comments_min_index_3 ON edits_comments_min(MinTimestampDiffAbs);

#CREATE INDEX edits_comments_index_1 ON edits_comments(PostHistoryId);
#CREATE INDEX edits_comments_index_2 ON edits_comments(CommentId);
#CREATE INDEX edits_comments_index_3 ON edits_comments(TimestampDiff);

#create table edits_comments_final
#select
#  e.PostHistoryId as PostHistoryId,
#  e.CommentId as CommentId,
#  TimestampDiff
#from edits_comments_filtered e
#join edits_comments_min e_min
#on e.PostHistoryId = e_min.PostHistoryId
#  and e.CommentId = e_min.CommentId
#  and abs(e.TimestampDiff) = e_min.MinTimestampDiffAbs;

  
# join takes too long on our server hardware -> export to CSV and join using BigQuery

select PostHistoryId, CommentId, MinTimestampDiffAbs
from edits_comments_min
into outfile '/data/tmp/edits_comments_min.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostHistoryId, CommentId, TimestampDiff
from edits_comments_filtered
into outfile '/data/tmp/edits_comments.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

####################################################
# BigQuery
##########
select
  e.PostHistoryId as PostHistoryId,
  e.CommentId as CommentId,
  TimestampDiff
from `edits_comments.edits_comments` e
join `edits_comments.edits_comments_min` e_min
on e.PostHistoryId = e_min.PostHistoryId
  and e.CommentId = e_min.CommentId
  and abs(e.TimestampDiff) = e_min.MinTimestampDiffAbs;
####################################################

 

# export for analysis in BigQuery

select
  PostId,
  CreationDate as Timestamp,
  Id as PostHistoryId
from PostHistory
where PostHistoryTypeId in (2, 5, 8)
into outfile '/data/tmp/post_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select
  PostId,
  CreationDate as Timestamp,
  Id as VoteId,
  case VoteTypeId
    when 2 then 1
    else NULL
  end as UpVote,
  case VoteTypeId
    when 3 then 1
    else NULL
  end as DownVote
from Votes
where VoteTypeId in (2, 3) # (upvote, downvote)
into outfile '/data/tmp/post_votes.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

  
####################################################
# BigQuery
########## 
  
####################################################
  
 

