#!/bin/bash

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

7za a stackoverflow_2017-03-14.7z *.xml
rm *.xml
