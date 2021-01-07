#!/bin/bash

sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent20_12"

# absolute path to XML and CSV files (consider MySQL's secure-file-priv option)
data_path="E:/Temp" # Cygwin
#data_path="/tmp" # Linux

rm -f $log_file

if [ "$1" = "so-dump"  ]; then
	echo "Exporting $1 tables..." | tee -a "$log_file"
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db Users -r $data_path/so-dump/Users.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db Badges -r $data_path/so-dump/Badges.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostLinks -r $data_path/so-dump/PostLinks.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db Tags -r $data_path/so-dump/Tags.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db Votes -r $data_path/so-dump/Votes.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db Comments -r $data_path/so-dump/Comments.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db Posts -r $data_path/so-dump/Posts.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostHistory -r $data_path/so-dump/PostHistory.sql
elif [ "$1" = "sotorrent" ]; then
	echo "Exporting $1 tables..." | tee -a "$log_file"
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostBlockDiff -r $data_path/sotorrent/PostBlockDiff.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostVersion -r $data_path/sotorrent/PostVersion.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostBlockVersion -r $data_path/sotorrent/PostBlockVersion.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostVersionUrl -r $data_path/sotorrent/PostVersionUrl.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db CommentUrl -r $data_path/sotorrent/CommentUrl.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db TitleVersion -r $data_path/sotorrent/TitleVersion.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db StackSnippetVersion -r $data_path/sotorrent/StackSnippetVersion.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostViews -r $data_path/sotorrent/PostViews.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostTags -r $data_path/sotorrent/PostTags.sql
elif [ "$1" = "gh-references" ]; then
	echo "Exporting $1 tables..." | tee -a "$log_file"
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db PostReferenceGH -r $data_path/gh-references/PostReferenceGH.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db GHMatches -r $data_path/gh-references/GHMatches.sql
	mysqldump -usotorrent -p$sotorrent_password --default-character-set=utf8mb4 $sotorrent_db GHCommits -r $data_path/gh-references/GHCommits.sql
else
	echo 'The first argument must be either "so-dump" or "sotorrent".' | tee -a "$log_file"
fi

echo "Finished." | tee -a "$log_file"
