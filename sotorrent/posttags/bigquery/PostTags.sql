SELECT temp.PostId AS PostId, tags.Id AS TagId
FROM `sotorrent-org.2020_03_15.Tags` tags
JOIN `sotorrent-org.2020_03_15.PostTagsTemp` temp
ON tags.TagName = temp.Tag;

=> `sotorrent-org.2020_03_15.PostTags`
