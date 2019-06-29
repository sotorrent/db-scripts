## Importing the SOTorrent dataset

1. Unzip all CSV and XML files.

   Windows (e.g. using [Cygwin](https://www.cygwin.com/) or [7zip](https://www.7-zip.org/)):

   `7za e *.7z`

   Linux (e.g. using [p7zip](https://sourceforge.net/projects/p7zip/)):

   `for file in ./*.7z; do 7z e "$file"; done`
   
2. Edit the SQL script `2_create_sotorrent_user.sql` to choose a password for the `sotorrent` user and execute the script to create the user.

3. Update the paths in `3_load_so_from_xml.sql`, `6_load_sotorrent.sql`, and `7_load_gh_references.sql` according to your configuration.

4. Run the below script in your MySQL client.

Import into MySQL database:

    source 1_create_database.sql; # create the database and tables for the SO dum
    source 2_create_sotorrent_user.sql; # create sotorrent user
    source 3_load_so_from_xml.sql; # import the SO dump from the XML files (please use the XML files provided by us, they have been processed to be compatible with MySQL)
    source 4_create_indices.sql; # create the indices for the SO tables
    source 5_create_sotorrent_tables.sql; # add the SOTorrent tables to the SO database
    source 6_load_sotorrent.sql; # import the SOTorrent tables from the CSV files
    source 7_load_gh_references.sql; # import the references from GitHub projects to Stack Overflow questions, answers, or comments and the matched source code lines with Stack Overflow references from GitHub projects
    source 8_create_sotorrent_indices.sql; # create the indices for the SOTorrent tables

## Data

The Stack Overflow data has been extracted from the official [Stack Exchange data dump](https://archive.org/details/stackexchange) released 2019-06-03.

The GitHub references have been retrieved from the [Google BigQuery GitHub data set](https://cloud.google.com/bigquery/public-data/github) on 2019-06-21 (last updated 2019-06-21 according to table info).

## MySQL Troubleshooting

### Ubuntu and Windows: Configuration used to test the dataset

We used the following configuration to test the dataset. See also the remarks below this section.

Client configuration:

    [mysql]
    ...
    default-character-set=utf8mb4
    ...

Server configuration:

    [mysqld]
    ...
    collation-server=utf8mb4_unicode_ci
    secure-file-priv="/data/tmp" # update path as needed
    tmp_table_size=1G
    myisam_max_sort_file_size=100G
    myisam_sort_buffer_size=1G
    key_buffer_size=256M
    read_buffer_size=128K
    read_rnd_buffer_size=256K
    innodb_flush_log_at_trx_commit=1
    innodb_log_buffer_size=1M
    innodb_buffer_pool_size=48G
    innodb_log_file_size=48M
    join_buffer_size=256M
    open_files_limit=4161
    sort_buffer_size=256M
    table_definition_cache=1400
    ...

### Ubuntu: AppArmor prevents access to files

In case an `OS errno 13 - Permission denied` error prevents you from importing the files, you may need to update your AppArmor configuration:

    sudo vim /etc/apparmor.d/usr.sbin.mysqld
    
    ...
    # Allow data dir access
      /var/lib/mysql/ r,
      /var/lib/mysql/** rwk,
      /data/tmp/** rwk, # add this line (update path as needed)
    ...
    
    sudo /etc/init.d/apparmor reload

### Windows: Camel-case table names

Add this to your server configuration:

    [mysqld]
    ...
    lower_case_table_names=2
    ...
