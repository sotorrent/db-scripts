#!/bin/sh

root_password="_AqUjvtv68E\$N!r]"
sotorrent_password="4ar7JKS2mfgGHiDA"
log_file="sotorrent.log"
sotorrent_db="sotorrent20_12"
db_init=false
load_so=false
load_gh=false
load_sotorrent=false

# absolute path to SQL dump files (consider MySQL's secure-file-priv option)
data_path="E:/Temp" # Cygwin
#data_path="/tmp" # Linux

sql_import_prefix="SET autocommit=0; SET unique_checks=0; SET foreign_key_checks=0;"
sql_import_suffix="SET unique_checks=1; SET foreign_key_checks=1; COMMIT; SET autocommit=1;";

rm -f $log_file

echo "Available command-line arguments: 'so-dump', 'sotorrent', 'gh-references', 'complete'."
echo "If called with second parameter 'db-init', a new database is initialized."

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
elif [ "$1" = "sotorrent" ]; then
	load_so=false
	load_gh=false
	load_sotorrent=true
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
	for file in $data_path/so-dump/*.sql; do
		mysql -u root --password="$root_password" --database="$sotorrent_db" --execute="USE $sotorrent_db; $sql_import_prefix SOURCE $file; $sql_import_suffix";
	done
	
	echo "Creating indices for Stack Overflow tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" --database="$sotorrent_db" < ./sql/create_so_indices.sql >> $log_file  2>&1
fi

if [ "$load_gh" = true ] ; then 
	echo "Loading GitHub references tables..." | tee -a "$log_file"
	for file in $data_path/gh-references/*.sql; do
		mysql -u root --password="$root_password" --database="$sotorrent_db" --execute="USE $sotorrent_db; $sql_import_prefix SOURCE $file; $sql_import_suffix";
	done
	
	echo "Creating indices for GH References tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" --database="$sotorrent_db" < ./sql/create_gh-references_indices.sql >> $log_file  2>&1
fi

if [ "$load_sotorrent" = true ] ; then 
	echo "Loading SOTorrent tables..." | tee -a "$log_file"
	for file in $data_path/sotorrent/*.sql; do
		mysql -u root --password="$root_password" --database="$sotorrent_db" --execute="USE $sotorrent_db; $sql_import_prefix SOURCE $file; $sql_import_suffix";
	done
	
	echo "Creating indices for SOTorrent tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" --database="$sotorrent_db" < ./sql/create_sotorrent_indices.sql >> $log_file  2>&1
fi

echo "Finished." | tee -a "$log_file"
