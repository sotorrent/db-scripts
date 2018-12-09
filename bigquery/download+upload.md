# How to download/upload files from/to Google Cloud using the command line (Ubuntu)

(1) Install and initialize Google Cloud SDK:

    https://cloud.google.com/sdk/downloads#apt-get

(2) Download files from a storage bucket:

    gsutil cp gs://sotorrent/*.csv.gz ./

(3) Upload files to a storage bucket:

    gsutil cp Users.csv gs://sotorrent/
    gsutil cp Badges.csv gs://sotorrent/
    gsutil cp Posts.csv gs://sotorrent/
    gsutil cp Comments.csv gs://sotorrent/
    gsutil cp PostHistory.csv gs://sotorrent/
    gsutil cp PostLinks.csv gs://sotorrent/
    gsutil cp Tags.csv gs://sotorrent/
    gsutil cp Votes.csv gs://sotorrent/
    
    gsutil cp PostBlockDiff.csv gs://sotorrent/
    gsutil cp PostVersion.csv gs://sotorrent/
    gsutil cp PostBlockVersion.csv gs://sotorrent/
    gsutil cp PostVersionUrl.csv gs://sotorrent/
    gsutil cp CommentUrl.csv gs://sotorrent/
    gsutil cp TitleVersion.csv gs://sotorrent/ 
      
    gsutil cp PostReferenceGH.csv gs://sotorrent/
