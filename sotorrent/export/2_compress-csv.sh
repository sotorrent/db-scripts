#!/bin/bash

if [ "$1" = "so-dump" ]; then
  7za a Badges.csv.7z Badges.csv && rm Badges.csv
  7za a Comments.csv.7z Comments.csv && rm Comments.csv
  7za a PostHistory.csv.7z PostHistory.csv && rm PostHistory.csv
  7za a PostLinks.csv.7z PostLinks.csv && rm PostLinks.csv
  7za a Posts.csv.7z Posts.csv && rm Posts.csv
  7za a Tags.csv.7z Tags.csv && rm Tags.csv
  7za a Users.csv.7z Users.csv && rm Users.csv
  7za a Votes.csv.7z Votes.csv && rm Votes.csv
elif [ "$1" = "sotorrent" ]; then
  7za a PostBlockDiff.csv.7z PostBlockDiff.csv && rm PostBlockDiff.csv
  7za a PostVersion.csv.7z PostVersion.csv && rm PostVersion.csv
  7za a PostBlockVersion.csv.7z PostBlockVersion.csv && rm PostBlockVersion.csv
  7za a PostVersionUrl.csv.7z PostVersionUrl.csv && rm PostVersionUrl.csv
  7za a CommentUrl.csv.7z CommentUrl.csv && rm CommentUrl.csv
  7za a TitleVersion.csv.7z TitleVersion.csv && rm TitleVersion.csv
  7za a StackSnippetVersion.csv.7z StackSnippetVersion.csv && rm StackSnippetVersion.csv
  7za a PostViews.csv.7z PostViews.csv && rm PostViews.csv
  7za a PostTags.csv.7z PostTags.csv && rm PostTags.csv
fi
