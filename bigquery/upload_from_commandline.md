# How to upload files to Google Cloud using the command line (Ubuntu)

(1) Install and initialize Google Cloud SDK:

    https://cloud.google.com/sdk/downloads#apt-get

(2) Upload files to storage bucket:

    gsutil cp Posts.csv gs://sotorrent/
    gsutil cp PostHistory.csv gs://sotorrent/
