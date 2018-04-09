# How to upload files to Google Cloud using the command line (Ubuntu)

(1) Install and initialize Google Cloud SDK:

    https://cloud.google.com/sdk/downloads#apt-get

(2) Upload files to storage bucket:

    gsutil cp Users.csv gs://sotorrent/
    gsutil cp Badges.csv gs://sotorrent/
    gsutil cp Posts.csv gs://sotorrent/
    gsutil cp Comments.csv gs://sotorrent/
    gsutil cp PostHistory.csv gs://sotorrent/
    gsutil cp PostLinks.csv gs://sotorrent/
    gsutil cp Tags.csv gs://sotorrent/
    gsutil cp Votes.csv gs://sotorrent/
