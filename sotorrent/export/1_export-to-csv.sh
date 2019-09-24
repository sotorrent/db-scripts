#!/bin/sh

sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent19_09"

# absolute path to XML and CSV files (consider MySQL's secure-file-priv option)
# escape slashes in path because the string is used in a sed command
data_path="F:\/Temp\/" # Cygwin
#data_path="\/tmp\/" # Linux

rm -f $log_file

if [ "$1" = "so-dump"  ] || [ "$1" = "sotorrent" ]; then
	echo "Exporting $1 tables..." | tee -a "$log_file"
	sed -e"s/<PATH>/$data_path/g" "./sql/export_$1.sql" > "./sql/export_$1_absolute_paths.sql"
	mysql $sotorrent_db -u sotorrent --password="$sotorrent_password" < "./sql/export_$1_absolute_paths.sql" >> $log_file  2>&1
	rm "./sql/export_$1_absolute_paths.sql"	
else
	echo 'The first argument must be either "so-dump" or "sotorrent".' | tee -a "$log_file"
fi

echo "Finished." | tee -a "$log_file"
