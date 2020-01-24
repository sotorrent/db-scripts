#!/bin/bash

project="sotorrent-org"
dataset="gh_so_references_2019_12_25"
sotorrent="2019_12_25"
bucket="sotorrent"
logfile="bigquery.log"

# "Table Info" of table "bigquery-public-data:github_repos.contents"
# Last Modified: Jan 24, 2020, 6:19:07 AM
# Number of Rows: 264,153,976 
# Table Size: 2.25 TB

# "Table Info" of table "bigquery-public-data:github_repos.commits"
# Last Modified: Jan 24, 2020, 5:55:03 AM
# Number of Rows: 237,651,394
# Table Size: 774 GB

# select all source code lines of text files that contain a link to Stack Overflow
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_lines" "$(< sql/matched_lines.sql)" >> "$logfile" 2>&1

# normalize the SO links, map them to http://stackoverflow.com/(a/q)/<id> or comment link
# extract post id and comment id from links
sed -e"s/<DATASET>/$dataset/g" ./sql/matched_lines_aq_template.sql > ./sql/matched_lines_aq.sql
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_lines_aq" "$(< sql/matched_lines_aq.sql)" >> "$logfile" 2>&1
rm ./sql/matched_lines_aq.sql

# join with table "files" to get information about repositories
# extract file extension from path
sed -e"s/<DATASET>/$dataset/g" ./sql/matched_files_aq_template.sql > ./sql/matched_files_aq.sql
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_files_aq" "$(< sql/matched_files_aq.sql)" >> "$logfile" 2>&1
rm ./sql/matched_files_aq.sql

# validate post ids and comments ids
sed -e"s/<DATASET>/$dataset/g" ./sql/matched_files_aq_filtered_template.sql | sed -e"s/<SOTORRENT>/$sotorrent/g" > ./sql/matched_files_aq_filtered.sql
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_files_aq_filtered" "$(< sql/matched_files_aq_filtered.sql)" >> "$logfile" 2>&1
rm ./sql/matched_files_aq_filtered.sql

# use camel case for column names, add number of copies, and split repo name for export to MySQL database
sed -e"s/<DATASET>/$dataset/g" ./sql/PostReferenceGH_template.sql > ./sql/PostReferenceGH.sql
bq --headless query --max_rows=0 --destination_table "$project:$dataset.PostReferenceGH" "$(< sql/PostReferenceGH.sql)" >> "$logfile" 2>&1
rm ./sql/PostReferenceGH.sql

# save matched lines is a separate table
sed -e"s/<DATASET>/$dataset/g" ./sql/GHMatches_template.sql > ./sql/GHMatches.sql
bq --headless query --max_rows=0 --destination_table "$project:$dataset.GHMatches" "$(< sql/GHMatches.sql)" >> "$logfile" 2>&1
rm ./sql/GHMatches.sql

# retrieve Stack Overflow links from commits
sed -e"s/<SOTORRENT>/$sotorrent/g" ./sql/GHCommits_template.sql > ./sql/GHCommits.sql
bq --headless query --max_rows=0 --destination_table "$project:$dataset.GHCommits" "$(< sql/GHCommits.sql)" >> "$logfile" 2>&1
rm ./sql/GHCommits.sql

# export PostReferenceGH and GHMatches
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.PostReferenceGH" "gs://$bucket/PostReferenceGH*.csv.gz"
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.GHMatches" "gs://$bucket/GHMatches*.csv.gz"
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.GHMatches" "gs://$bucket/GHCommits*.csv.gz"

# download compressed CSV files
gsutil cp "gs://$bucket/*.csv.gz" ./

# merge CSV files
./sh/merge_csv_files_PostReferenceGH.sh
./sh/merge_csv_files_GHMatches.sh
#./sh/merge_csv_files_GHCommits.sh

# remove CSV files in the cloud
gsutil rm "gs://$bucket/*.csv.gz"

# zip local CSV files
7za a PostReferenceGH.csv.7z PostReferenceGH.csv && rm PostReferenceGH.csv
7za a GHMatches.csv.7z GHMatches.csv && rm GHMatches.csv
#7za a GHCommits.csv.7z GHCommits.csv && rm GHCommits.csv