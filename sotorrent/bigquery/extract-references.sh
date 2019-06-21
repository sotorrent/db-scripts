#!/bin/bash

project="sotorrent-org"
dataset="gh_so_references_2019_06_21"
bucket="sotorrent"
logfile="bigquery.log"

# "Table Info" of table "bigquery-public-data:github_repos.contents"
# Last Modified: Jun 21, 2019, 7:40:56 AM 
# Number of Rows: 260,103,914
# Table Size: 2.21 TB 

# select all source code lines of text files that contain a link to Stack Overflow
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_lines" "$(< sql/matched_lines.sql)" &>> "$logfile"

# normalize the SO links, map them to http://stackoverflow.com/(a/q)/<id> or comment link
# extract post id and comment id from links
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_lines_aq" "$(< sql/matched_lines_aq.sql)" &>> "$logfile"

# join with table "files" to get information about repositories
# extract file extension from path
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_files_aq" "$(< sql/matched_files_aq.sql)" &>> "$logfile"

# validate post ids and comments ids
bq --headless query --max_rows=0 --destination_table "$project:$dataset.matched_files_aq_filtered" "$(< sql/matched_files_aq_filtered.sql)" &>> "$logfile"

# use camel case for column names, add number of copies, and split repo name for export to MySQL database
bq --headless query --max_rows=0 --destination_table "$project:$dataset.PostReferenceGH" "$(< sql/PostReferenceGH.sql)" &>> "$logfile"

# save matched lines is a separate table
bq --headless query --max_rows=0 --destination_table "$project:$dataset.GHMatches" "$(< sql/GHMatches.sql)" &>> "$logfile"

# export PostReferenceGH and GHMatches
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.PostReferenceGH" "gs://$bucket/PostReferenceGH*.csv.gz"
bq extract --destination_format "CSV" --compression "GZIP" "$project:$dataset.GHMatches" "gs://$bucket/GHMatches*.csv.gz"

# download compressed CSV files
gsutil cp "gs://$bucket/*.csv.gz" ./

# merge CSV files
./merge_csv_files_PostReferenceGH.sh
./merge_csv_files_GHMatches.sh

# remove CSV files in the cloud
gsutil rm "gs://$bucket/*.csv.gz"
