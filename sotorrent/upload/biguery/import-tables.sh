#!/bin/bash

project="sotorrent-org"
dataset="2020_08_31"
bucket="sotorrent"
logfile="bigquery.log"
gcloud_mysql_instance="sotorrent"
gcloud_mysql_db="sotorrent20_06"
glcoud_mysql_connection="sotorrent-org.US.sotorrent20_06"

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
	echo "Decompressing $1 files..." | tee -a "$log_file"
	for file in ./so-dump-bigquery/*.7z; do 7z e "$file" -o./so-dump/; done
	
	# upload SQL dumps to Google Cloud Bucket
	echo "Uploading $1 SQL dumps..." | tee -a "$log_file"
	gsutil cp so-dump-bigquery/Users.sql gs://$bucket/
	gsutil cp so-dump-bigquery/Badges.sql gs://$bucket/
	gsutil cp so-dump-bigquery/PostLinks.sql gs://$bucket/
	gsutil cp so-dump-bigquery/Tags.sql gs://$bucket/
	gsutil cp so-dump-bigquery/Votes.sql gs://$bucket/
	gsutil cp so-dump-bigquery/Comments.sql gs://$bucket/
	gsutil cp so-dump-bigquery/Posts.sql gs://$bucket/
	gsutil cp so-dump-bigquery/PostHistory.sql gs://$bucket/

	# test database connection
	#gcloud sql connect $gcloud_mysql_instance --user=sotorrent;

	# import SQL dumps into Google Cloud MySQL instance

	echo "Importing $1 SQL dumps into MySQL instance..." | tee -a "$log_file"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Badges.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostLinks.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Tags.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud beta sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Users.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Votes.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Comments.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/Posts.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1.5h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostHistory.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 2h
	
	echo "Copying $1 tables from MySQL instance to BigQuery..." | tee -a "$log_file"
	
		bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Badges\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Badges;\");"
	
		bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostLinks\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostLinks;\");"
	
		bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Tags\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Tags;\");"
	
		bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Users\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Users;\");"
	
		bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Votes\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Votes;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Comments\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Comments;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.Posts\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM Posts;\");"
	
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
	echo "Decompressing $1 files..." | tee -a "$log_file"
	for file in ./sotorrent/*.7z; do 7z e "$file" -o./sotorrent/; done

	echo "Uploading $1 SQL dumps..." | tee -a "$log_file"
	gsutil cp sotorrent/PostBlockDiff.sql gs://$bucket/
	gsutil cp sotorrent/PostVersion.sql gs://$bucket/
	gsutil cp sotorrent/PostBlockVersion.sql gs://$bucket/
	gsutil cp sotorrent/PostVersionUrl.sql gs://$bucket/
	gsutil cp sotorrent/CommentUrl.sql gs://$bucket/
	gsutil cp sotorrent/TitleVersion.sql gs://$bucket/ 
	gsutil cp sotorrent/StackSnippetVersion.sql gs://$bucket/   
	gsutil cp sotorrent/PostViews.sql gs://$bucket/   
	gsutil cp sotorrent/PostTags.sql gs://$bucket/   
	
	echo "Importing $1 SQL dumps into MySQL instance..." | tee -a "$log_file"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostBlockDiff.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1.5h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostVersion.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostBlockVersion.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 5h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostVersionUrl.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/CommentUrl.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/TitleVersion.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/TitleVersion.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/StackSnippetVersion.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostViews.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostTags.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	echo "Copying $1 tables from MySQL instance to BigQuery..." | tee -a "$log_file"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostBlockDiff\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostBlockDiff;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostVersion;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostBlockVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostBlockVersion;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostVersionUrl\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostVersionUrl;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.CommentUrl\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM CommentUrl;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.TitleVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM TitleVersion;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.StackSnippetVersion\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM StackSnippetVersion;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostViews\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostViews;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostTags\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostTags;\");"
fi

if [ "$load_gh" = true ] ; then 
	echo "Decompressing $1 SQL dumps..." | tee -a "$log_file"
	for file in ./gh-references/*.7z; do 7z e "$file" -o./gh-references/; done
	
	echo "Uploading $1 tables..." | tee -a "$log_file"
	gsutil cp gh-references/PostReferenceGH.sql gs://$bucket/
	gsutil cp gh-references/GHMatches.sql gs://$bucket/
	gsutil cp gh-references/GHCommits.sql gs://$bucket/

	echo "Importing $1 SQL dumps into MySQL instance..." | tee -a "$log_file"
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/PostReferenceGH.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/GHMatches.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
		gcloud sql import sql --quiet \
	  $gcloud_mysql_instance \
	  gs://$bucket/GHCommits.sql \
	  --database=$gcloud_mysql_db;
	
	sleep 1h
	
	echo "Copying $1 tables from MySQL instance to BigQuery..." | tee -a "$log_file"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.PostReferenceGH\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM PostReferenceGH;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.GHMatches\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM GHMatches;\");"
	
	bq query --nouse_legacy_sql \
	"CREATE TABLE \`$dataset.GHCommits\`
	AS SELECT * FROM EXTERNAL_QUERY(\"$glcoud_mysql_connection\", \"SELECT * FROM GHCommits;\");"
fi

if [ "$delete_csv" = true ] ; then 
	# remove CSV files in the cloud
	gsutil rm "gs://$bucket/*.csv"
fi
