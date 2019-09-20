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

rm -f $log_file

if [ "$1" = "so-only" ]; then
	echo "Won't attempt to load SOTorrent tables." | tee -a "$log_file"
	load_sotorrent=false
fi

echo "Creating database..." | tee -a "$log_file"
mysql -u root --password="$root_password" -e "DROP DATABASE IF EXISTS $sotorrent_db;
  SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE $sotorrent_db DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;"

echo "Creating Stack Overflow tables..." | tee -a "$log_file"
mysql $sotorrent_db -u root --password="$root_password" < ./1_create_so_tables.sql >> $log_file  2>&1

echo "Adding database user and granting privileges..." | tee -a "$log_file"
mysql -u root --password="$root_password" -e "CREATE USER IF NOT EXISTS 'sotorrent'@'localhost' IDENTIFIED BY '$sotorrent_password';
  CREATE USER IF NOT EXISTS 'sotorrent'@'%' IDENTIFIED BY '$sotorrent_password';
  GRANT ALL PRIVILEGES ON $sotorrent_db.* TO 'sotorrent'@'localhost';
  GRANT ALL PRIVILEGES ON $sotorrent_db.* TO 'sotorrent'@'%';
  GRANT FILE ON *.* TO 'sotorrent'@'localhost';
  GRANT FILE ON *.* TO 'sotorrent'@'%'; FLUSH PRIVILEGES;"

echo "Loading Stack Overflow tables..." | tee -a "$log_file"
sed -e"s/<PATH>/$data_path/g" 2_load_so_from_xml.sql > 2_load_so_from_xml_absolute_paths.sql
mysql $sotorrent_db -u root --password="$root_password" < ./2_load_so_from_xml_absolute_paths.sql >> $log_file  2>&1
rm 2_load_so_from_xml_absolute_paths.sql

echo "Creating indices for Stack Overflow tables..." | tee -a "$log_file"
mysql $sotorrent_db -u root --password="$root_password" < ./3_create_so_indices.sql >> $log_file  2>&1

echo "Creating SOTorrent tables..." | tee -a "$log_file"
mysql $sotorrent_db -u root --password="$root_password" < ./4_create_sotorrent_tables.sql >> $log_file  2>&1

if [ "$load_sotorrent" = true ] ; then 
	echo "Loading SOTorrent tables..." | tee -a "$log_file"
	sed -e"s/<PATH>/$data_path/g" 5_load_sotorrent.sql > 5_load_sotorrent_paths.sql
	mysql $sotorrent_db -u root --password="$root_password" < ./5_load_sotorrent_paths.sql >> $log_file  2>&1
	rm 5_load_sotorrent_paths.sql
	
	echo "Creating indices for SOTorrent tables..." | tee -a "$log_file"
	mysql $sotorrent_db -u root --password="$root_password" < ./6_create_sotorrent_indices.sql >> $log_file  2>&1
fi

echo "Finished." | tee -a "$log_file"
