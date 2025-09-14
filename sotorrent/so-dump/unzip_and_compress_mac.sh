#!/bin/bash
set -Eeuo pipefail

# unzip XML files
7zz e stackoverflow.com.7z

# compress individual XML files
7zz a Badges.xml.7z Badges.xml
7zz a Comments.xml.7z Comments.xml
7zz a PostHistory.xml.7z PostHistory.xml
7zz a PostLinks.xml.7z PostLinks.xml
7zz a Posts.xml.7z Posts.xml
7zz a Tags.xml.7z Tags.xml
7zz a Users.xml.7z Users.xml
7zz a Votes.xml.7z Votes.xml
