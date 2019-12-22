#!/bin/sh

root_password="_AqUjvtv68E\$N!r]"
sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent19_09"
load_sotorrent=true

# absolute path to XML and CSV files (consider MySQL's secure-file-priv option)
# escape slashes in path because the string is used in a sed command
data_path="F:\/Temp\/" # Cygwin
#data_path="\/tmp\/" # Linux

declare -a datadump_versions=("2016-09-12")

rm -f $log_file

if [ "$1" = "so-only" ]; then
	echo "Won't attempt to load SOTorrent tables." | tee -a "$log_file"
	load_sotorrent=false
fi

echo "Loading PostViews tables..." | tee -a "$log_file"
for version in ${datadump_versions[@]}; do
    version_path="$data_path$version\/"
    echo "Reading PostViews.xml from $version_path..."
    
	sed -e"s/<PATH>/$version_path/g" ./sql/load_postviews.sql | sed -e"s/<VERSION>/$version/g" > ./sql/load_postviews_absolute_paths.sql
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/load_postviews_absolute_paths.sql >> $log_file  2>&1
	# rm ./sql/load_postviews_absolute_paths.sql
done

echo "Finished." | tee -a "$log_file"
