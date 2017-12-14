#!/bin/bash

sed -e 's/TagBased="False"/TagBased="0"/' Badges.xml > tmp.xml
sed -e 's/TagBased="True"/TagBased="1"/' tmp.xml > Badges.xml
