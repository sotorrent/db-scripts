#!/bin/bash

# unzip XML files
7za e stackoverflow.com-Badges.7z && rm stackoverflow.com-Badges.7z
7za e stackoverflow.com-Comments.7z && rm stackoverflow.com-Comments.7z
7za e stackoverflow.com-PostHistory.7z && rm stackoverflow.com-PostHistory.7z
7za e stackoverflow.com-PostLinks.7z && rm stackoverflow.com-PostLinks.7z
7za e stackoverflow.com-Posts.7z && rm stackoverflow.com-Posts.7z
7za e stackoverflow.com-Tags.7z && rm stackoverflow.com-Tags.7z
7za e stackoverflow.com-Users.7z && rm stackoverflow.com-Users.7z
7za e stackoverflow.com-Votes.7z && rm stackoverflow.com-Votes.7z

# adapt XML for MySQL import
sed -e 's/TagBased="False"/TagBased="0"/' Badges.xml > tmp.xml && sed -e 's/TagBased="True"/TagBased="1"/' tmp.xml > Badges.xml && rm tmp.xml

# MySQL automatically parse (and modifies) XML-esspaced characters
# Therefore, replace the carriage return/newline characters as follows
# '&#xD;' --> '\r'
# '&#xA;' --> '\n'
sed -e 's/\&#xD;/\r/g' Comments.xml > tmp.xml && sed -e 's/\&#xA;/\n/g' tmp.xml > Comments.xml && rm tmp.xml
sed -e 's/\&#xD;/\r/g' Posts.xml > tmp.xml && sed -e 's/\&#xA;/\n/g' tmp.xml > Posts.xml && rm tmp.xml
sed -e 's/\&#xD;/\r/g' PostHistory.xml > tmp.xml && sed -e 's/\&#xA;/\n/g' tmp.xml > PostHistory.xml && rm tmp.xml

# compress XML files
7za a Badges.xml.7z Badges.xml
7za a Comments.xml.7z Comments.xml
7za a PostHistory.xml.7z PostHistory.xml
7za a PostLinks.xml.7z PostLinks.xml
7za a Posts.xml.7z Posts.xml
7za a Tags.xml.7z Tags.xml
7za a Users.xml.7z Users.xml
7za a Votes.xml.7z Votes.xml
