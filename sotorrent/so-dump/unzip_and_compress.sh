#!/bin/bash
set -Eeuo pipefail

# unzip XML files
7za e stackoverflow.com.7z

# compress individual XML files
7za a Badges.xml.7z Badges.xml
7za a Comments.xml.7z Comments.xml
7za a PostHistory.xml.7z PostHistory.xml
7za a PostLinks.xml.7z PostLinks.xml
7za a Posts.xml.7z Posts.xml
7za a Tags.xml.7z Tags.xml
7za a Users.xml.7z Users.xml
7za a Votes.xml.7z Votes.xml
