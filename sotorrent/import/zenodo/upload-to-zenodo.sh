#!/bin/bash

ZENODO_TOKEN=""
DEPOSIT_ID="2628274"
#curl "https://zenodo.org/api/deposit/depositions/$DEPOSIT_ID?access_token=$ZENODO_TOKEN" | grep -Eo '"links":{"download":"https://zenodo\.org/api/files/[^/]+'
ZENODO_BUCKET="40db99da-4e7f-4419-98b6-317b162d71c6"

upload_file() {
	FILE_PATH="$1"
	FILE_NAME="$(basename $FILE_PATH)"
	printf "\nUploading file $FILE_PATH...\n"
	curl --upload-file "$FILE_PATH" "https://zenodo.org/api/files/$ZENODO_BUCKET/$FILE_NAME?access_token=$ZENODO_TOKEN"
} 

upload_file "gh-references/GHMatches.csv.7z"
upload_file "gh-references/PostReferenceGH.csv.7z"

upload_file "so-dump/Badges.xml.7z"
upload_file "so-dump/Comments.xml.7z"
upload_file "so-dump/PostHistory.xml.7z"
upload_file "so-dump/PostLinks.xml.7z"
upload_file "so-dump/Posts.xml.7z"
upload_file "so-dump/Tags.xml.7z"
upload_file "so-dump/Users.xml.7z"
upload_file "so-dump/Votes.xml.7z"

upload_file "sotorrent/CommentUrl.csv.7z"
upload_file "sotorrent/PostBlockDiff.csv.7z"
upload_file "sotorrent/PostBlockVersion.csv.7z"
upload_file "sotorrent/PostVersion.csv.7z"
upload_file "sotorrent/PostVersionUrl.csv.7z"
upload_file "sotorrent/TitleVersion.csv.7z"
upload_file "sotorrent/StackSnippetVersion.csv.7z"
