#!/bin/bash
set -Eeuo pipefail

# Before executing this script, create a new dataset version and delete the old files on the Zenodo website

ZENODO_TOKEN="" # update this
ZENODO_BUCKET="3532c8a9-395e-4f0c-8048-13e7e519b3d7" # update this (see get-zenodo-bucket-id.sh)

# absolute path to SQL dump files (consider MySQL's secure-file-priv option)
data_path="D:/DataDumps/sotorrent/sotorrent_2020-12-31/data" # Cygwin
#data_path="/tmp/" # Linux

upload_file() {
	FILE_PATH="$1"
	FILE_NAME="$(basename $FILE_PATH)"
	printf "\nUploading file $FILE_PATH...\n"
	curl --upload-file "$FILE_PATH" "https://zenodo.org/api/files/$ZENODO_BUCKET/$FILE_NAME?access_token=$ZENODO_TOKEN"
} 

echo "Uploading so-dump..."
for file in $data_path/so-dump/*.sql.7z; do
	upload_file "$file";
done

echo "Uploading sotorrent..."
for file in $data_path/sotorrent/*.sql.7z; do
	upload_file "$file";
done

echo "Uploading gh-references..."
for file in $data_path/gh-references/*.sql.7z; do
	upload_file "$file";
done
