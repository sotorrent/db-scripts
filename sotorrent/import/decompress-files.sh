#!/bin/bash

for file in ./gh-references/*.7z; do 7z e "$file" -o./gh-references/; done
for file in ./so-dump-bigquery/*.7z; do 7z e "$file" -o./so-dump-bigquery/; done
for file in ./sotorrent/*.7z; do 7z e "$file" -o./sotorrent/; done
