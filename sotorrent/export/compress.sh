#!/bin/bash
set -Eeuo pipefail

if [ "$1" = "so-dump" ]; then
	echo "Compressing $1 SQL files..."
	for file in ./so-dump/*.sql; do
		7z a "$file.7z" "$file" -o./so-dump/ && rm "$file";
	done
elif [ "$1" = "sotorrent" ]; then
	echo "Compressing $1 SQL files..."
	for file in ./sotorrent/*.sql; do
		7z a "$file.7z" "$file" -o./sotorrent/ && rm "$file";
	done
elif [ "$1" = "gh-references" ]; then
	echo "Compressing $1 SQL files..."
	for file in ./gh-references/*.sql; do
		7z a "$file.7z" "$file" -o./gh-references/ && rm "$file";
	done
else
  echo 'The first argument must be either "so-dump" or "sotorrent".'
fi
