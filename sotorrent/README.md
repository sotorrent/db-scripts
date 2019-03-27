## Importing the SOTorrent data set

1. Unzip all CSV and XML files: `gunzip *.gz`. On macOS, please use the build-in "Archive Utility" instead (see this [issue description](https://github.com/sotorrent/db-scripts/issues/7)).
2. Edit the SQL script `2_create_sotorrent_user.sql` to choose a password for the sotorrent user and execute the script to create the user.
3. Update the paths in files `3_load_so_from_xml.sql`, `6_load_sotorrent.sql`, `7_load_postreferencegh.sql`, and `8_load_ghmatches.sql`.
4. Run the below script in your MySQL client.

Import into MySQL database:

    source 1_create_database.sql; # create the database and tables for the SO dum
    source 2_create_sotorrent_user.sql; # create sotorrent user
    source 3_load_so_from_xml.sql; # import the SO dump from the XML files (please use the XML files provided by us, they are processed to be compatible with MySQL)
    source 4_create_indices.sql; # create the indices for the SO tables
    source 5_create_sotorrent_tables.sql; # add the SOTorrent tables to the SO database
    source 6_load_sotorrent.sql; # import the SOTorrent tables from the CSV files
    source 7_load_postreferencegh.sql; # import the references from GitHub projects to Stack Overflow questions, answers, or comments
    source 8_load_ghmatches.sql; # import the matched source code lines with Stack Overflow references from GitHub projects
    source 9_create_sotorrent_indices.sql; # create the indices for the SOTorrent tables

## Data

The Stack Overflow data has been extracted from the official [Stack Exchange data dump](https://archive.org/details/stackexchange) released 2019-03-04.

The GitHub references have been retrieved from the [Google BigQuery GitHub data set](https://cloud.google.com/bigquery/public-data/github) on 2019-03-17 (last updated 2019-03-15 according to table info).
