#!/bin/bash

# on some systems, you need to replace md5sum by md5

# absolute path to SQL dump files (consider MySQL's secure-file-priv option)
data_path="D:/DataDumps/sotorrent/sotorrent_2020-12-31/data" # Cygwin
#data_path="/tmp/" # Linux

md5sum $data_path/so-dump/Badges.sql.7z
md5sum $data_path/so-dump/Comments.sql.7z
md5sum $data_path/sotorrent/CommentUrl.sql.7z
md5sum $data_path/gh-references/GHCommits.sql.7z
md5sum $data_path/gh-references/GHMatches.sql.7z
md5sum $data_path/sotorrent/PostBlockDiff.sql.7z
md5sum $data_path/sotorrent/PostBlockVersion.sql.7z
md5sum $data_path/so-dump/PostHistory.sql.7z
md5sum $data_path/so-dump/PostLinks.sql.7z
md5sum $data_path/gh-references/PostReferenceGH.sql.7z
md5sum $data_path/so-dump/Posts.sql.7z
md5sum $data_path/sotorrent/PostTags.sql.7z
md5sum $data_path/sotorrent/PostVersion.sql.7z
md5sum $data_path/sotorrent/PostVersionUrl.sql.7z
md5sum $data_path/sotorrent/PostViews.sql.7z
md5sum $data_path/sotorrent/StackSnippetVersion.sql.7z
md5sum $data_path/so-dump/Tags.sql.7z
md5sum $data_path/sotorrent/TitleVersion.sql.7z
md5sum $data_path/so-dump/Users.sql.7z
md5sum $data_path/so-dump/Votes.sql.7z
