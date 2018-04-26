use analysis;

##########
# Get Java posts (to compare all vs. Java posts)
##########
select Id as PostId, PostTypeId
from JavaQuestions
into outfile 'F:/Temp/java_questions.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select Id as PostId, PostTypeId
from JavaAnswers
into outfile 'F:/Temp/java_answers.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# Analyze post scores
##########
select Id as PostId, PostTypeId, Score
from sotorrent17_12.Posts
where PostTypeId in (1, 2)
into outfile 'F:/Temp/posts_score.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# Number of text/code blocks per post
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
    from sotorrent17_12.PostVersion
    group by PostId, PostTypeId
  ) p
  join (
    select PostId, min(PostHistoryId) as FirstPostHistoryId
    from sotorrent17_12.PostVersion
    group by PostId
  ) p_first
  on p.PostId = p_first.PostId
) p2
join (
  select PostId, max(PostHistoryId) as LastPostHistoryId
  from sotorrent17_12.PostVersion
  group by PostId
) p_last
on p2.PostId = p_last.PostId
into outfile 'F:/Temp/posts_versioncount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostId, PostHistoryId, count(Id) as TextBlockCount
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=1
group by PostId, PostHistoryId
into outfile 'F:/Temp/posts_textblockcount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostId, PostHistoryId, count(Id) as CodeBlockCount
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=2
group by PostId, PostHistoryId
into outfile 'F:/Temp/posts_codeblockcount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##################################################
# Correlations
##################################################

# Correlate the following measures with the version count

##########
# Is code in upvoted posts changed more often?
##########
##########
# Is code in posts with many comments changed more often?
##########
##########
# Is code in old posts changed more often?
##########
select
  Id as PostId,
  PostTypeId,
  Score,
  CommentCount,
  TIMESTAMPDIFF(DAY, CreationDate, "2017-12-31 23:59:00") as Age,
  OwnerUserId
from sotorrent17_12.Posts
WHERE PostTypeId in (1, 2)
into outfile 'F:/Temp/posts_metadata.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Are code snippets found on GH more likely to be revised (consider number of distinct files)?
##########
select PostId, count(distinct FileId) as GHMatchCount
from sotorrent17_12.PostReferenceGH
group by PostId
into outfile 'F:/Temp/posts_gh-matches.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Does author reputation influence the versioncount?
##########
select Id as UserId, Reputation
from sotorrent17_12.Users
into outfile 'F:/Temp/users_reputation.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##################################################


##########
# Length of all text block lifespans
##########
select pbv.PostId as PostId, PostTypeId, RootPostBlockId, count(pbv.Id) as LifespanLength
from sotorrent17_12.PostBlockVersion pbv
left join sotorrent17_12.PostVersion pv
on pbv.PostId = pv.PostId
where PostBlockTypeId=1 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostTypeId, RootPostBlockId
into outfile 'F:/Temp/textblock_lifespan_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Length of all code block lifespans
##########
select pbv.PostId as PostId, PostTypeId, RootPostBlockId, count(pbv.Id) as LifespanLength
from sotorrent17_12.PostBlockVersion pbv
left join sotorrent17_12.PostVersion pv
on pbv.PostId = pv.PostId
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostTypeId, RootPostBlockId
into outfile 'F:/Temp/codeblock_lifespan_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Are text and code blocks changed together?
##########
select PostId, PostHistoryId, Count(Id) as TextBlockEdits
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=1 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostHistoryId
into outfile 'F:/Temp/textblock_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select PostId, PostHistoryId, Count(Id) as TextBlockEdits
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, PostHistoryId
into outfile 'F:/Temp/codeblock_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# Length of text blocks
##########
select PostId, PostHistoryId, Id as PostBlockVersionId, Length, LineCount
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=1
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile 'F:/Temp/textblock_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Length of code blocks
##########
select PostId, PostHistoryId, Id as PostBlockVersionId, Length, LineCount
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=2
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile 'F:/Temp/codeblock_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Length of text blocks over time (only consider changes)
##########
select PostId, RootPostBlockId, Id as PostBlockVersionId, Length, LineCount
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=1 and (PredEqual IS NULL or PredEqual=0)
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile 'F:/Temp/textblock_length_over_time.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Length of code blocks over time (only consider changes)
##########
select PostId, RootPostBlockId, Id as PostBlockVersionId, Length, LineCount
from sotorrent17_12.PostBlockVersion
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0)
order by PostId, RootPostBlockId, PostBlockVersionId, Length, LineCount
into outfile 'F:/Temp/codeblock_length_over_time.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Analyze who edited the posts
##########
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
  from sotorrent17_12.PostHistory ph
  left join sotorrent17_12.Users u
  on ph.UserId = u.Id
  where PostHistoryTypeId in (2, 5, 8)
) ph_u
left join sotorrent17_12.Posts p
on ph_u.PostId = p.Id
where PostTypeId in (1, 2)
into outfile 'F:/Temp/posthistory_users.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

##########
# Analyze timespan between the edits
##########
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
    pv.CreationDate as CreationDate,
    SuccPostHistoryId
  from sotorrent17_12.PostVersion pv
  join sotorrent17_12.PostHistory ph
  on pv.PostHistoryId = ph.Id
) pv1
left join sotorrent17_12.PostHistory ph1
on pv1.SuccPostHistoryId = ph1.Id
into outfile 'F:/Temp/postversion_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# Retrieve lines deleted/added (BigQuery)
##########
select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, sum(LineCount) as LinesDeleted
from (
  select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, count(Line) as LineCount
  from (
    select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, split(Text, '&#xD;&#xA;') as Lines
    from `2018_02_16.PostBlockDiff`
    where PostBlockDiffOperationId=-1
  )
  cross join unnest(Lines) as Line
  where length(trim(Line))>0
  group by PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId
)
group by PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId;

=> analysis_2018_02_16.PostBlockVersion_LinesDeleted
=> postblockversion_linesdeleted.csv

select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, sum(LineCount) as LinesAdded
from (
  select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, count(Line) as LineCount
  from (
    select PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId, split(Text, '&#xD;&#xA;') as Lines
    from `2018_02_16.PostBlockDiff`
    where PostBlockDiffOperationId=1
  )
  cross join unnest(Lines) as Line
  where length(trim(Line))>0
  group by PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId
)
group by PostId, PostHistoryId, PostBlockVersionId, PredPostBlockVersionId;

=> analysis_2018_02_16.PostBlockVersion_LinesAdded
=> postblockversion_linesadded.csv


select Id as PostBlockVersionId, PostBlockTypeId
from sotorrent17_12.PostBlockVersion
group by PostBlockVersionId, PostBlockTypeId
into outfile 'F:/Temp/postblockversion_type.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# Order of post blocks
##########
select p1.Id as PostBlockVersionId, (p2.LocalId - p1.LocalId) as LocalIdDiff
from sotorrent17_12.PostBlockVersion p1
join sotorrent17_12.PostBlockVersion p2
on p1.PredPostBlockId = p2.Id
into outfile 'F:/Temp/postblockversion_localiddiff.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# Compare edits and comment/vote dates
##########
select
  PostId,
  Date,
  SUM(Creation) as Creation,
  SUM(Edit) as Edits
from (
  select
    PostId,
    date(CreationDate) as Date,
    case
		when PostHistoryTypeId = 2
		then 1 
		else 0
	end as Creation,
	case
		when PostHistoryTypeId in (5, 8)
		then 1
		else 0
	end as Edit
  from sotorrent17_12.PostHistory
  where PostHistoryTypeId in (2, 5, 8)
) edits
group by PostId, Date
into outfile 'F:/Temp/posthistory_date_editcount.csv'
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
  from sotorrent17_12.Comments
) comments
group by PostId, Date
into outfile 'F:/Temp/comments_date_commentcount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

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
  from sotorrent17_12.Votes
  where VoteTypeId in (2, 3) # (upvote, downvote)
) votes
group by PostId, Date
into outfile 'F:/Temp/votes_date_votecount.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


##########
# Analyze edits and comments happening on the same day
##########

# edits and comments per post and day
create table edits_comments_aggregated as
select
  edits_aggregated.PostId as PostId,
  edits_aggregated.Date as Date,
  EditCount,
  CommentCount
from (
  # edits per post and day
  select
    PostId,
    Date,
    Count(PostHistoryId) as EditCount
  from (
    select
      PostId,
      date(CreationDate) as Date,
      Id as PostHistoryId
    from sotorrent17_12.PostHistory
    where PostHistoryTypeId in (5, 8) # do not consider 2 here, because we are only interested in the edits
  ) edits
  group by PostId, Date
) edits_aggregated
join (
  # comments per post and day
  select
    PostId,
    Date,
    Count(CommentId) as CommentCount
  from (
    select
      PostId,
      date(CreationDate) as Date,
      Id as CommentId
    from sotorrent17_12.Comments
  ) comments
  group by PostId, Date
) comments_aggregated
on edits_aggregated.PostId = comments_aggregated.PostId
  and edits_aggregated.Date = comments_aggregated.Date;

  
# (edit, comment) tuples that happened on same day, with time difference between them
create table edits_comments as
select
  comments_edits_same_day.PostId as PostId,
  comments_edits_same_day.Date as Date,
  CommentId,
  CommentTimestamp,
  PostHistoryId,
  EditTimestamp,
  TIMESTAMPDIFF(SECOND, EditTimestamp, CommentTimestamp) as TimestampDiff,
  PostHistoryTypeId
from (
	# all comments (with timestamp) that happened on days were also an edit happened
	select
	  post_dates.PostId as PostId,
	  post_dates.Date as Date,
	  CommentId,
	  CommentTimestamp
	from (
	  # (PostId, Date) tuples with at least one edit and at least one comment
	  select PostId, Date
	  from edits_comments_aggregated
	  where EditCount>0 & CommentCount>0
	) post_dates
	join (
	  select
		PostId,
		date(CreationDate) as Date,
		CreationDate as CommentTimestamp,
		Id as CommentId
	  from sotorrent17_12.Comments
	) comments
	on post_dates.PostId = comments.PostId
	  and post_dates.Date = comments.Date
) comments_edits_same_day
join (
  # add post edits with timestamp
  select
    PostId,
    date(CreationDate) as Date,
    CreationDate as EditTimestamp,
    Id as PostHistoryId,
	PostHistoryTypeId
  from sotorrent17_12.PostHistory
  where PostHistoryTypeId in (2, 5, 8) # consider 2 here to be able to match comments that were close to the creation, exclude them later
) ph
on comments_edits_same_day.PostId = ph.PostId
  and comments_edits_same_day.Date = ph.Date;
  
# get time difference to edit that is closest to comment
create table edits_comments_min_timestamp as
select
  PostHistoryId,
  CommentId,
  min(abs(TimestampDiff)) as MinTimestampDiffAbs
from edits_comments
group by PostHistoryId, CommentId;

# create indices
CREATE INDEX edits_comments_index_1 ON edits_comments(PostHistoryId);
CREATE INDEX edits_comments_index_2 ON edits_comments(CommentId);
CREATE INDEX edits_comments_index_3 ON edits_comments(TimestampDiff);
CREATE INDEX edits_comments_min_timestamp_index_1 ON edits_comments_min_timestamp(PostHistoryId);
CREATE INDEX edits_comments_min_timestamp_index_2 ON edits_comments_min_timestamp(CommentId);
CREATE INDEX edits_comments_min_timestamp_index_3 ON edits_comments_min_timestamp(MinTimestampDiffAbs);

# get post versions (PostHistoryId) together with comments on the same day and their time difference to the edit
# also write PostHistoryId to allow filtering (exclude intial creation)
create table edits_comments_final as
select
  e.PostHistoryId as PostHistoryId,
  e.CommentId as CommentId,
  TimestampDiff,
  PostHistoryTypeId
from edits_comments e
join edits_comments_min_timestamp e_min
on e.PostHistoryId = e_min.PostHistoryId
  and e.CommentId = e_min.CommentId
  and abs(e.TimestampDiff) = e_min.MinTimestampDiffAbs;

# write final table to CSV
select * from edits_comments_final
into outfile 'F:/Temp/edits_comments_final.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

# write (PostId, PostHistoryId) mapping to CSV (needed for drawing sample for qualitative analysis)
# see R script "analysis_edits_vs_comments+votes.R"
select PostId, Id as PostHistoryId
from sotorrent17_12.PostHistory
group by PostId, PostHistoryId
into outfile 'F:/Temp/postid_posthistoryid.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

# write (PostId, PostTypeId) mapping to CSV (needed for creating links to SO posts)
# see R script "analysis_edits_vs_comments+votes.R"
select Id as PostId, PostTypeId
from sotorrent17_12.Posts
group by PostId, PostTypeId
into outfile 'F:/Temp/postid_posttypeid.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

  
 
##########
# Analysis of edits vs. votes
##########

# get votes per post together with timestamp
create table post_votes as
select
  PostId,
  CreationDate as Timestamp,
  Id as VoteId,
  case VoteTypeId
    when 2 then 1
    else 0
  end as UpVote,
  case VoteTypeId
    when 3 then 1
    else 0
  end as DownVote
from sotorrent17_12.Votes
where VoteTypeId in (2, 3);  # (upvote, downvote)

CREATE INDEX post_votes_index_1 ON post_votes(PostId);
CREATE INDEX post_votes_index_2 ON post_votes(VoteId);


# get PostHistoryIds of first post versions
create table first_versions as
select
  PostId,
  min(Id) as PostHistoryId,
  min(CreationDate) as Timestamp
from sotorrent17_12.PostHistory
where PostHistoryTypeId in (2, 5, 8)
group by PostId;

CREATE INDEX first_versions_index_1 ON first_versions(PostId);
CREATE INDEX first_versions_index_2 ON first_versions(PostHistoryId);


# get PostHistoryIds of first edits (second version)
create table first_edits as
select
  PostId,
  min(PostHistoryId) as PostHistoryId,
  min(Timestamp) as Timestamp
from (
	select
	  PostId,
	  Id as PostHistoryId,
	  CreationDate as Timestamp
	from sotorrent17_12.PostHistory
	where PostHistoryTypeId in (2, 5, 8)
) e
where PostHistoryId > (
    select PostHistoryId
    from first_versions
    where PostId = e.PostId
)
group by PostId;

CREATE INDEX first_edits_index_1 ON first_edits(PostId);
CREATE INDEX first_edits_index_2 ON first_edits(PostHistoryId);

# select first edits that were done at least one week after the creation of the post
create table sample_edits as
select
  e.PostId as PostId,
  e.PostHistoryId as PostHistoryId,
  e.Timestamp as Timestamp
from first_edits e
join first_versions v
on e.PostId = v.PostId
where TIMESTAMPDIFF(DAY, v.Timestamp, e.Timestamp) >= 7;

CREATE INDEX sample_edits_index_1 ON sample_edits(PostId);
CREATE INDEX sample_edits_index_2 ON sample_edits(PostHistoryId);


# get upvotes up to one week before and after edit
create table sample_edits_votes as
select
  e.PostId as PostId,
  PostHistoryId,
  VoteId,
  # edit before vote -> diff negative
  TIMESTAMPDIFF(DAY, v.Timestamp, e.Timestamp) as TimespanDiff
from sample_edits e
left join post_votes v
on e.PostId = v.PostId
where UpVote > 0
  and abs(TIMESTAMPDIFF(DAY, v.Timestamp, e.Timestamp)) <= 7;

CREATE INDEX sample_edits_votes_index_1 ON sample_edits_votes(PostId);
CREATE INDEX sample_edits_votes_index_2 ON sample_edits_votes(PostHistoryId);
CREATE INDEX sample_edits_votes_index_3 ON sample_edits_votes(VoteId); 
  
# write data to CSV files for analysis
select
  PostId,
  count(VoteId) as UpVotes
from sample_edits_votes
where TimespanDiff<0 and VoteId is not null
group by PostId
into outfile 'F:/Temp/sample_votes_after_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

select
  PostId,
  count(VoteId) as UpVotes
from sample_edits_votes
where TimespanDiff>0 and VoteId is not null
group by PostId
into outfile 'F:/Temp/sample_votes_before_edits.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';


 

