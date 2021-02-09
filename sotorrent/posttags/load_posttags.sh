#!/bin/sh
set -Eeuo pipefail

root_password="_AqUjvtv68E\$N!r]"
sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent20_12"

# absolute path to XML and CSV files (consider MySQL's secure-file-priv option)
# escape slashes in path because the string is used in a sed command
data_path="E:\/Temp\/" # Cygwin
#data_path="\/tmp\/" # Linux

rm -f $log_file

echo "Loading PostTags table..." | tee -a "$log_file"
dir=`pwd`
cd "$data_path"
echo "Extracting PostTags.csv.7z in $data_path..."
#7za e "PostTags.csv.7z"
cd "$dir"
echo "Reading PostTags.csv from $data_path..."
sed -e"s/<PATH>/$data_path/g" ./sql/load_posttags.sql | sed -e"s/<VERSION>/$version/g" > ./sql/load_posttags_absolute_paths.sql
mysql $sotorrent_db -u root --password="$root_password" < ./sql/load_posttags_absolute_paths.sql >> $log_file  2>&1
#rm ./sql/load_posttags_absolute_paths.sql
cd "$data_path"
#rm "PostTags.csv"
cd "$dir"

echo "Finished." | tee -a "$log_file"
