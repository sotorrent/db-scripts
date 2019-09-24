#!/bin/bash

gsutil cp so-dump-bigquery/Users.csv gs://sotorrent/
gsutil cp so-dump-bigquery/Badges.csv gs://sotorrent/
gsutil cp so-dump-bigquery/Posts.csv gs://sotorrent/
gsutil cp so-dump-bigquery/Comments.csv gs://sotorrent/
gsutil cp so-dump-bigquery/PostHistory.csv gs://sotorrent/
gsutil cp so-dump-bigquery/PostLinks.csv gs://sotorrent/
gsutil cp so-dump-bigquery/Tags.csv gs://sotorrent/
gsutil cp so-dump-bigquery/Votes.csv gs://sotorrent/

gsutil cp sotorrent/PostBlockDiff.csv gs://sotorrent/
gsutil cp sotorrent/PostVersion.csv gs://sotorrent/
gsutil cp sotorrent/PostBlockVersion.csv gs://sotorrent/
gsutil cp sotorrent/PostVersionUrl.csv gs://sotorrent/
gsutil cp sotorrent/CommentUrl.csv gs://sotorrent/
gsutil cp sotorrent/TitleVersion.csv gs://sotorrent/ 
  
gsutil cp gh-references/PostReferenceGH.csv gs://sotorrent/
gsutil cp gh-references/GHMatches.csv gs://sotorrent/
