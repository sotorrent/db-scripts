#!/bin/sh

root_password="_AqUjvtv68E\$N!r]"
sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent20_03"

# absolute path to XML and CSV files (consider MySQL's secure-file-priv option)
# escape slashes in path because the string is used in a sed command
data_path="F:\/Temp\/" # Cygwin
#data_path="\/tmp\/" # Linux

rm -f $log_file

echo "Creating temporary PostTags table..." | tee -a "$log_file"
mysql $sotorrent_db -u root --password="$root_password" < ./sql/create_posttags_temp.sql >> $log_file  2>&1

echo "Loading temporary PostTags table..." | tee -a "$log_file"
sed -e"s/<PATH>/$data_path/g" ./sql/load_posttags_temp.sql > ./sql/load_posttags_temp_absolute_paths.sql
echo "Reading PostTags.xml from $data_path..."
mysql $sotorrent_db -u root --password="$root_password" < ./sql/load_posttags_temp_absolute_paths.sql >> $log_file  2>&1
rm ./sql/load_posttags_temp_absolute_paths.sql

echo "Deleting temporary PostTags table..." | tee -a "$log_file"
mysql $sotorrent_db -u root --password="$root_password" < ./sql/delete_posttags_temp.sql >> $log_file  2>&1

echo "Finished." | tee -a "$log_file"

# Next step: Upload table to BigQuery and replace tags by tag ids
