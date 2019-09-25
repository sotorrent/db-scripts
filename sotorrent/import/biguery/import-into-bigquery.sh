#!/bin/bash

project="sotorrent-org"
dataset="2019_09_23"
bucket="sotorrent"
logfile="bigquery.log"

# TODO: copy or create type tables

# import CSV files without header row
bq load --source_format=CSV "$project:$dataset.Badges" "gs://$bucket/Badges.csv" ./schema/Badges.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.Comments" "gs://$bucket/Comments.csv" ./schema/Comments.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.CommentUrl" "gs://$bucket/CommentUrl.csv" ./schema/CommentUrl.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.PostBlockDiff" "gs://$bucket/PostBlockDiff.csv" ./schema/PostBlockDiff.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.PostBlockType" "gs://$bucket/PostBlockType.csv" ./schema/PostBlockType.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.PostBlockVersion" "gs://$bucket/PostBlockVersion.csv" ./schema/PostBlockVersion.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.PostHistory" "gs://$bucket/PostHistory.csv" ./schema/PostHistory.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.PostLinks" "gs://$bucket/PostLinks.csv" ./schema/PostLinks.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.Posts" "gs://$bucket/Posts.csv" ./schema/Posts.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.PostVersion" "gs://$bucket/PostVersion.csv" ./schema/PostVersion.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.PostVersionUrl" "gs://$bucket/PostVersionUrl.csv" ./schema/PostVersionUrl.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.StackSnippetVersion" "gs://$bucket/StackSnippetVersion.csv" ./schema/StackSnippetVersion.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.Tags" "gs://$bucket/Tags.csv" ./schema/Tags.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.TitleVersion" "gs://$bucket/TitleVersion.csv" ./schema/TitleVersion.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.Users" "gs://$bucket/Users.csv" ./schema/Users.json &>> "$logfile"
bq load --source_format=CSV "$project:$dataset.Votes" "gs://$bucket/Votes.csv" ./schema/Votes.json &>> "$logfile"

# import CSV files with header row
bq load --source_format=CSV --skip_leading_rows=1 "$project:$dataset.GHMatches" "gs://$bucket/GHMatches.csv" ./schema/GHMatches.json &>> "$logfile"
bq load --source_format=CSV --skip_leading_rows=1 "$project:$dataset.PostReferenceGH" "gs://$bucket/PostReferenceGH.csv" ./schema/PostReferenceGH.json &>> "$logfile"

# remove CSV files in the cloud
gsutil rm "gs://$bucket/*.csv.gz"
