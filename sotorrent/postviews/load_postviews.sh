#!/bin/sh
set -Eeuo pipefail

root_password="_AqUjvtv68E\$N!r]"
sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent20_12"

# absolute path to XML and CSV files (consider MySQL's secure-file-priv option)
# escape slashes in path because the string is used in a sed command
data_path="E:\/Temp\/postviews\/" # Cygwin
#data_path="\/tmp\/" # Linux

declare -a datadump_versions=("2016-09-12" "2016-12-15" "2017-03-14" "2017-06-12" "2017-12-01" "2018-03-13" "2018-06-05" "2018-09-05" "2018-12-02" "2019-03-04" "2019-06-03" "2019-09-04" "2019-12-02" "2020-03-02" "2020-06-02" "2020-09-08" "2020-12-08")

rm -f $log_file

echo "Loading PostViews tables..." | tee -a "$log_file"
for version in ${datadump_versions[@]}; do
	version_path="$data_path$version\/"
	dir=`pwd`
	cd "$version_path"
	echo "Extracting PostViews.csv.7z in $version_path..."
	7za e "PostViews.csv.7z"
	cd "$dir"
	echo "Reading PostViews.csv from $version_path..."
	sed -e"s/<PATH>/$version_path/g" ./sql/load_postviews.sql | sed -e"s/<VERSION>/$version/g" > ./sql/load_postviews_absolute_paths.sql
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/load_postviews_absolute_paths.sql >> $log_file  2>&1
	rm ./sql/load_postviews_absolute_paths.sql
	cd "$version_path"
	rm "PostViews.csv"
	cd "$dir"
done

echo "Finished." | tee -a "$log_file"
