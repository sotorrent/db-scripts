#!/bin/bash

function merge_csvs() {
	prefix="$1"
	suffix="$2"
	let "partition_count= $3 - 1"
	first_file="${prefix}_0_${suffix}.csv"
	output_file="${prefix}_${suffix}.csv"
	
	echo "Merging CSV files with prefix $prefix and suffix $suffix..."
	# ensure newline add end of file
	sed -i'' -e '$a\' ${first_file}
	
	# remove numbering for first file (will be target for other files)
	mv ${first_file} "${prefix}_${suffix}.csv"
	
	# append content of other CSV files
	for i in $(seq 1 $partition_count);
	do
	  current_file="${prefix}_${i}_${suffix}.csv"
	  echo "Appending $current_file..."
	  sed -i'' -e '$a\' ${current_file}
	  tail -n +2 ${current_file} >> "$output_file"
	  rm ${current_file}
	done
}

merge_csvs "all_answers" "no_blocks" 6
merge_csvs "all_questions" "no_blocks" 6

merge_csvs "all_answers" "no_content_versions" 6
merge_csvs "all_questions" "no_content_versions" 6

merge_csvs "all_answers" "no_title_versions" 6
merge_csvs "all_questions" "no_title_versions" 6
