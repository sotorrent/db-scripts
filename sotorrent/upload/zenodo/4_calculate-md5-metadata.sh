#!/bin/bash
set -Eeuo pipefail

# on some systems, you need to replace md5sum by md5

# absolute path to SQL dump files (consider MySQL's secure-file-priv option)
data_path="D:/DataDumps/sotorrent/sotorrent_2020-12-31/data" # Cygwin
#data_path="/tmp/" # Linux

md5sum $data_path/LICENSE.md
md5sum $data_path/load_sotorrent.sh
md5sum $data_path/README.md
md5sum $data_path/sql.7z
