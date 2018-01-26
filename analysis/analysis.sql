
# length of all code block lifespans
select PostId, RootPostBlockId, count(Id) as LifespanLength
from PostBlockVersion
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0) 
group by PostId, RootPostBlockId
into outfile '/data/tmp/code_block_lifespan_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

# length of code blocks over time
select Id, PostId, RootPostBlockId, Length, LineCount
from PostBlockVersion
where PostBlockTypeId=2 and (PredEqual IS NULL or PredEqual=0)
order by PostId, RootPostBlockId, Id, Length, LineCount
into outfile '/data/tmp/code_block_length.csv'
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n';

# create table to analyze who edited the posts
create table PostHistoryUsers as
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
ON ph_u.PostId = p.Id
WHERE PostTypeId in (1, 2);

# create table to analyze the time between the edits
create table PostVersionCreationDate as
select
	pv2.PostId as PostId,
  pv2.PostTypeId as PostTypeId,
  pv2.PostHistoryId as PostHistoryId,
  pv2.PostHistoryTypeId as PostHistoryTypeId,
  pv2.CreationDate as CreationDate,
  pv2.PredPostHistoryId as PredPostHistoryId,
  pv2.PredPostHistoryTypeId as PredPostHistoryTypeId,
  pv2.PredCreationDate as PredCreationDate,
  pv2.PredCreationDateDiff as PredCreationDateDiff,
  pv2.SuccPostHistoryId as SuccPostHistoryId,
  ph2.PostHistoryTypeId as SuccPostHistoryTypeId,
  ph2.CreationDate as SuccCreationDate,
  TIMESTAMPDIFF(DAY, pv2.CreationDate, ph2.CreationDate) as SuccCreationDateDiff
from (
	select
		pv1.PostId as PostId,
		pv1.PostTypeId as PostTypeId,
		pv1.PostHistoryId as PostHistoryId,
		pv1.PostHistoryTypeId as PostHistoryTypeId,
		pv1.CreationDate as CreationDate,
		pv1.PredPostHistoryId as PredPostHistoryId,
    ph1.PostHistoryTypeId as PredPostHistoryTypeId,
		ph1.CreationDate as PredCreationDate,
    TIMESTAMPDIFF(DAY, pv1.CreationDate, ph1.CreationDate) as PredCreationDateDiff,
		pv1.SuccPostHistoryId as SuccPostHistoryId
	from (
		select
			pv.PostId as PostId,
			PostTypeId,
			PostHistoryId,
			PostHistoryTypeId,
			CreationDate,
			PredPostHistoryId,
			SuccPostHistoryId
		from PostVersion pv
		join PostHistory ph
		on pv.PostHistoryId = ph.Id
	) pv1
	left join PostHistory ph1
	on PredPostHistoryId = Id
) pv2
left join PostHistory ph2
on pv2.SuccPostHistoryId = ph2.Id;

