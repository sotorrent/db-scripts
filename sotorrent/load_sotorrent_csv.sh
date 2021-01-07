#!/bin/sh

root_password="_AqUjvtv68E\$N!r]"
sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent20_12"
db_init=false
load_so=false
load_gh=false
load_sotorrent=false

# absolute path to XML and CSV files (consider MySQL's secure-file-priv option)
# escape slashes in path because the string is used in a sed command
data_path="E:\/Temp\/" # Cygwin
#data_path="\/tmp\/" # Linux

rm -f $log_file

echo "Available command-line arguments: 'so-dump', 'gh-references', 'complete'."
echo "If called with second parameter 'db-init', a new database is initalized."

if [ "$1" = "so-dump" ]; then
	echo "Will only load SO tables." | tee -a "$log_file"
	load_so=true
	load_gh=false
	load_sotorrent=false
elif [ "$1" = "gh-references" ]; then
	echo "Will only load GH tables." | tee -a "$log_file"
	load_so=false
	load_gh=true
	load_sotorrent=false
elif [ "$1" = "complete" ]; then
	echo "Will load all tables." | tee -a "$log_file"
	load_so=true
	load_gh=true
	load_sotorrent=true
fi

if [ "$2" = "db-init" ] ; then 
	db_init=true
	echo "Creating database..." | tee -a "$log_file"
	mysql -u root --password="$root_password" -e "DROP DATABASE IF EXISTS $sotorrent_db;
	  SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
	  CREATE DATABASE $sotorrent_db DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;"

	echo "Creating Stack Overflow tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/create_so_tables.sql >> $log_file  2>&1

	echo "Adding database user and granting privileges..." | tee -a "$log_file"
	mysql -u root --password="$root_password" -e "CREATE USER IF NOT EXISTS 'sotorrent'@'localhost' IDENTIFIED BY '$sotorrent_password';
	  CREATE USER IF NOT EXISTS 'sotorrent'@'%' IDENTIFIED BY '$sotorrent_password';
	  GRANT ALL PRIVILEGES ON $sotorrent_db.* TO 'sotorrent'@'localhost';
	  GRANT ALL PRIVILEGES ON $sotorrent_db.* TO 'sotorrent'@'%';
	  GRANT FILE ON *.* TO 'sotorrent'@'localhost';
	  GRANT FILE ON *.* TO 'sotorrent'@'%'; FLUSH PRIVILEGES;"
fi

if [ "$load_so" = true ] ; then 
	echo "Loading Stack Overflow tables..." | tee -a "$log_file"
	sed -e"s/<PATH>/$data_path/g" ./sql/load_so_from_xml.sql > ./sql/load_so_from_xml_absolute_paths.sql
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/load_so_from_xml_absolute_paths.sql >> $log_file  2>&1
	rm ./sql/load_so_from_xml_absolute_paths.sql

	echo "Creating indices for Stack Overflow tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/create_so_indices.sql >> $log_file  2>&1
fi

if [ "$db_init" = true ] ; then 
	echo "Creating SOTorrent tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/create_sotorrent_tables.sql >> $log_file  2>&1
fi

if [ "$load_gh" = true ] ; then 
	echo "Loading GH tables..." | tee -a "$log_file"
	sed -e"s/<PATH>/$data_path/g" ./sql/load_gh-references.sql > ./sql/load_gh-references_paths.sql
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/load_gh-references_paths.sql >> $log_file  2>&1
	rm ./sql/load_gh-references_paths.sql
	
	echo "Creating indices for GH References tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/create_gh-references_indices.sql >> $log_file  2>&1
fi

if [ "$load_sotorrent" = true ] ; then 
	echo "Loading SOTorrent tables..." | tee -a "$log_file"
	sed -e"s/<PATH>/$data_path/g" ./sql/load_sotorrent.sql > ./sql/load_sotorrent_paths.sql
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/load_sotorrent_paths.sql >> $log_file  2>&1
	rm ./sql/load_sotorrent_paths.sql
	
	echo "Creating indices for SOTorrent tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" < ./sql/create_sotorrent_indices.sql >> $log_file  2>&1
fi

echo "Finished." | tee -a "$log_file"
