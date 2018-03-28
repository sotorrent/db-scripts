#!/bin/bash

# unzip XML files
7za e stackoverflow.com-Badges.7z
rm stackoverflow.com-Badges.7z
7za e stackoverflow.com-Comments.7z
rm stackoverflow.com-Comments.7z
7za e stackoverflow.com-PostHistory.7z
rm stackoverflow.com-PostHistory.7z
7za e stackoverflow.com-PostLinks.7z
rm stackoverflow.com-PostLinks.7z
7za e stackoverflow.com-Posts.7z
rm stackoverflow.com-Posts.7z
7za e stackoverflow.com-Tags.7z
rm stackoverflow.com-Tags.7z
7za e stackoverflow.com-Users.7z
rm stackoverflow.com-Users.7z
7za e stackoverflow.com-Votes.7z
rm stackoverflow.com-Votes.7z

# adapt XML for MySQL import
sed -e 's/TagBased="False"/TagBased="0"/' Badges.xml > tmp.xml
sed -e 's/TagBased="True"/TagBased="1"/' tmp.xml > Badges.xml
rm tmp.xml

# zip XML files
gzip -k Badges.xml
gzip -k Comments.xml
gzip -k PostHistory.xml
gzip -k PostLinks.xml
gzip -k Posts.xml
gzip -k Tags.xml
gzip -k Users.xml
gzip -k Votes.xml
