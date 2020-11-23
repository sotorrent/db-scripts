#!/bin/bash

project="sotorrent-org"
dataset="gh_so_references_2020_11_22"
sotorrent="2020_11_16"
bucket="sotorrent"
logfile="bigquery.log"

# "Table Info" of table "bigquery-public-data:github_repos.commits"
# Last modified: Nov 19, 2020, 10:41:33 AM
# Number of Rows: 245,405,539
# Table Size: 795.15 GB
#
# Unique Git commits from open source repositories on GitHub, pre-grouped by repositories they appear in.

# "Table Info" of table "bigquery-public-data:github_repos.contents"
# Last Modified: Nov 19, 2020, 8:07:20 PM
# Number of Rows: 269,172,700
# Table Size: 2.31 TB
#
# Unique file contents of text files under 1 MiB on the HEAD branch.
# Can be joined to [bigquery-public-data:github_repos.files] table using the id columns to identify the repository and file path.

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

# export PostReferenceGH, GHMatches, and GHCommits
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.PostReferenceGH" "gs://$bucket/PostReferenceGH*.csv.gz"
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.GHMatches" "gs://$bucket/GHMatches*.csv.gz"
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.GHCommits" "gs://$bucket/GHCommits*.csv.gz"

# download compressed CSV files
gsutil cp "gs://$bucket/*.csv.gz" ./

# merge CSV files
./sh/merge_csv_files.sh PostReferenceGH 4
./sh/merge_csv_files.sh GHMatches 14
./sh/merge_csv_files.sh GHCommits 0

# remove CSV files in the cloud
gsutil rm "gs://$bucket/*.csv.gz"

# zip local CSV files
7za a PostReferenceGH.csv.7z PostReferenceGH.csv && 7za a GHMatches.csv.7z GHMatches.csv && 7za a GHCommits.csv.7z GHCommits.csv && rm *.csv && rm *.csv.gz
