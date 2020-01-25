#!/bin/bash

project="sotorrent-org"
dataset="2020_01_24"
bucket="sotorrent"
logfile="bigquery.log"

# import CSV files without header row
bq load --source_format=CSV "$project:$dataset.Badges" "gs://$bucket/Badges.csv" ./schema/Badges.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.Comments" "gs://$bucket/Comments.csv" ./schema/Comments.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.CommentUrl" "gs://$bucket/CommentUrl.csv" ./schema/CommentUrl.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostBlockDiff" "gs://$bucket/PostBlockDiff.csv" ./schema/PostBlockDiff.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostBlockType" "gs://$bucket/PostBlockType.csv" ./schema/PostBlockType.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostBlockVersion" "gs://$bucket/PostBlockVersion.csv" ./schema/PostBlockVersion.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostHistory" "gs://$bucket/PostHistory.csv" ./schema/PostHistory.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostLinks" "gs://$bucket/PostLinks.csv" ./schema/PostLinks.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.Posts" "gs://$bucket/Posts.csv" ./schema/Posts.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostVersion" "gs://$bucket/PostVersion.csv" ./schema/PostVersion.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostVersionUrl" "gs://$bucket/PostVersionUrl.csv" ./schema/PostVersionUrl.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.StackSnippetVersion" "gs://$bucket/StackSnippetVersion.csv" ./schema/StackSnippetVersion.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.Tags" "gs://$bucket/Tags.csv" ./schema/Tags.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.TitleVersion" "gs://$bucket/TitleVersion.csv" ./schema/TitleVersion.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.Users" "gs://$bucket/Users.csv" ./schema/Users.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.Votes" "gs://$bucket/Votes.csv" ./schema/Votes.json >> "$logfile" 2>&1
bq load --source_format=CSV "$project:$dataset.PostViews" "gs://$bucket/PostViews.csv" ./schema/PostViews.json >> "$logfile" 2>&1

# import CSV files with header row
bq load --source_format=CSV --skip_leading_rows=1 "$project:$dataset.GHMatches" "gs://$bucket/GHMatches.csv" ./schema/GHMatches.json >> "$logfile" 2>&1
bq load --source_format=CSV --skip_leading_rows=1 "$project:$dataset.PostReferenceGH" "gs://$bucket/PostReferenceGH.csv" ./schema/PostReferenceGH.json >> "$logfile" 2>&1
bq load --source_format=CSV --skip_leading_rows=1 "$project:$dataset.GHCommits" "gs://$bucket/GHCommits.csv" ./schema/GHCommits.json >> "$logfile" 2>&1

# create helper table that makes it easier to retrieve the parent id of a thread
bq --headless query --max_rows=0 --destination_table "$project:$dataset.Threads" "$(< sql/Threads.sql)" >> "$logfile" 2>&1

# remove CSV files in the cloud
gsutil rm "gs://$bucket/*.csv"
