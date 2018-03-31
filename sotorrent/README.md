## Importing the SOTorrent data set

1. Unzip all CSV and XML files: `gunzip *.gz`
2. Execute the SQL script `1_create_database.sql` in your database client (tested on MySQL 5.7) to create the database and tables for the SO dump.
3. Edit the SQL script `2_create_sotorrent_user.sql` to choose a password for the sotorrent user and execute the script to create the user.
4. Execute the SQL script `3_load_so_from_xml.sql` to import the SO dump from the XML files (please use the XML files provided by us, they are processed to be compatible with MySQL).
5. Execute the SQL script `4_create_indices.sql` to create the indices for the SO tables.
6. Execute the SQL script `5_create_sotorrent_tables.sql` to add the SOTorrent tables to the SO database.
7. Execute the SQL script `6_load_sotorrent.sql` to import the SOTorrent tables from the CSV files.
8. Execute the SQL script `7_load_postreferencegh.sql` to import the references from GitHub projects to SO from the CSV file PostReferenceGH.csv.
9. Execute the SQL script `8_create_sotorrent_indices.sql` to create the indices for the SOTorrent tables.

## Data

The Stack Overflow data has been extracted from the official [Stack Exchange data dump](https://archive.org/details/stackexchange) released 2018-03-13.

The GitHub references have been retrieved from the [Google BigQuery GitHub data set](https://cloud.google.com/bigquery/public-data/github) on 2018-03-31.
