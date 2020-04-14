#!/bin/bash

gsutil cp sotorrent/PostBlockDiff.csv gs://sotorrent/
gsutil cp sotorrent/PostVersion.csv gs://sotorrent/
gsutil cp sotorrent/PostBlockVersion.csv gs://sotorrent/
gsutil cp sotorrent/PostVersionUrl.csv gs://sotorrent/
gsutil cp sotorrent/CommentUrl.csv gs://sotorrent/
gsutil cp sotorrent/TitleVersion.csv gs://sotorrent/ 
gsutil cp sotorrent/StackSnippetVersion.csv gs://sotorrent/   
gsutil cp sotorrent/PostViews.csv gs://sotorrent/   
# PostTags already on BigQuery   
