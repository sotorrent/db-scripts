#!/bin/bash
set -Eeuo pipefail

input_directory="$1"

for directory in $input_directory/*
do
	echo "Compressing files in $directory..."
	for file in $directory/*.jsonl;
	do
		7z a "$file.7z" "$file" -o"$directory" && rm "$file";
	done
done
echo "Finished."
