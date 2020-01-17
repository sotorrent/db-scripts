#!/bin/bash

# Before executing this script, create a new dataset version and delete the old files using the Zendodo website

ZENODO_TOKEN="" # update this
DEPOSIT_ID="3595538" # update this
#curl "https://zenodo.org/api/deposit/depositions/$DEPOSIT_ID?access_token=$ZENODO_TOKEN" | grep -Eo '"links":{"download":"https://zenodo\.org/api/files/[^/]+'
ZENODO_BUCKET="1984a41f-5518-4c42-a0e6-78f79adb8fe9" # update this

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
upload_file "sotorrent/PostViews.csv.7z"
