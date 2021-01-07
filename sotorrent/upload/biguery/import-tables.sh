#!/bin/bash

project="sotorrent-org"
dataset="2020_12_31"
bucket="sotorrent"
logfile="bigquery.log"
gcloud_mysql_instance="sotorrent"
gcloud_mysql_db="sotorrent20_12"
glcoud_mysql_connection="sotorrent-org.US.sotorrent20_12"

# test database connection
#gcloud sql connect $gcloud_mysql_instance --user=sotorrent;

load_so=false
load_gh=false
load_sotorrent=false
delete_csv=false

rm -f "$logfile"

if [ "$1" = "so-dump" ]; then
	echo "Will only import SO tables." | tee -a "$logfile"
	load_so=true
	load_gh=false
	load_sotorrent=false
elif [ "$1" = "gh-references" ]; then
	echo "Will only import GH tables." | tee -a "$logfile"
	load_so=false
	load_gh=true
	load_sotorrent=false
elif [ "$1" = "sotorrent" ]; then
	echo "Will only import SOTorrent tables." | tee -a "$logfile"
	load_so=false
	load_gh=false
	load_sotorrent=true
else
	echo 'The first argument must be either "so-dump", "gh-references", or "sotorrent".' | tee -a "$logfile"
fi

if [ "$2" = "delete-csv" ]; then
	delete_csv=true
fi

if [ "$load_so" = true ] ; then 
	echo "Decompressing $1 files..." | tee -a "$logfile"
	for file in ./so-dump/*.7z; do 7z e "$file" -o./so-dump/; done
	
	echo "Uploading $1 SQL dumps, importing them into MySQL instance, and copying them into BigQuery dataset..." | tee -a "$logfile"
	
	gsutil cp so-dump/Users.sql gs://$bucket/	
	
	gcloud beta sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Users.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp so-dump/Badges.sql gs://$bucket/
	
	# at this point the import into MySQL is hopefully finished
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Users\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Users;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Badges.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp so-dump/PostLinks.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Badges\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Badges;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostLinks.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp so-dump/Tags.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostLinks\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostLinks;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Tags.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp so-dump/Votes.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Tags\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Tags;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Votes.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp so-dump/Comments.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Votes\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Votes;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Comments.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp so-dump/Posts.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Comments\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Comments;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Posts.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp so-dump/PostHistory.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Posts\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Posts;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostHistory.sql \
	  --database=$gcloud_mysql_db;
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostHistory\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostHistory;\");"
	
	# create helper table that makes it easier to retrieve the parent id of a thread
	sed -e"s/<PROJECT>/$project/g" "./sql/Threads.sql" > "./sql/Threads_tmp.sql"
	sed -e"s/<DATASET>/$dataset/g" "./sql/Threads_tmp.sql" > "./sql/Threads_populated.sql"
	rm ./sql/Threads_tmp.sql
	bq --headless query --max_rows=0 --destination_table "$project:$dataset.Threads" "$(< sql/Threads_populated.sql)" >> "$logfile" 2>&1
	rm ./sql/Threads_populated.sql
fi

if [ "$load_sotorrent" = true ] ; then 
	echo "Decompressing $1 files..." | tee -a "$logfile"
	for file in ./sotorrent/*.7z; do 7z e "$file" -o./sotorrent/; done
	
	echo "Uploading $1 SQL dumps, importing them into MySQL instance, and copying them into BigQuery dataset..." | tee -a "$logfile"
	
	gsutil cp sotorrent/PostVersion.sql gs://$bucket/
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostVersion.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/PostVersionUrl.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostVersion;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostVersionUrl.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/CommentUrl.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostVersionUrl\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostVersionUrl;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/CommentUrl.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/TitleVersion.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.CommentUrl\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM CommentUrl;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/TitleVersion.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/StackSnippetVersion.sql gs://$bucket/   
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.TitleVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM TitleVersion;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/StackSnippetVersion.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/PostViews.sql gs://$bucket/   
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.StackSnippetVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM StackSnippetVersion;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostViews.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/PostTags.sql gs://$bucket/  
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostViews\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostViews;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostTags.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/PostBlockDiff.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostTags\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostTags;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostBlockDiff.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp sotorrent/PostBlockVersion.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostBlockDiff\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostBlockDiff;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostBlockVersion.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 3h
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostBlockVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostBlockVersion;\");"
fi

if [ "$load_gh" = true ] ; then 
	echo "Decompressing $1 SQL dumps..." | tee -a "$logfile"
	for file in ./gh-references/*.7z; do 7z e "$file" -o./gh-references/; done
	
	echo "Uploading $1 SQL dumps, importing them into MySQL instance, and copying them into BigQuery dataset..." | tee -a "$logfile"
	
	gsutil cp gh-references/PostReferenceGH.sql gs://$bucket/
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostReferenceGH.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp gh-references/GHMatches.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostReferenceGH\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostReferenceGH;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/GHMatches.sql \
	  --database=$gcloud_mysql_db;
	
	gsutil cp gh-references/GHCommits.sql gs://$bucket/
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.GHMatches\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM GHMatches;\");"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/GHCommits.sql \
	  --database=$gcloud_mysql_db;
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.GHCommits\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM GHCommits;\");"
fi

if [ "$delete_csv" = true ] ; then 
	# remove CSV files in the cloud
	gsutil rm "gs://$bucket/*.csv"
fi
