SELECT temp.PostId AS PostId, tags.Id AS TagId
FROM `sotorrent-org.2020_11_12.Tags` tags
JOIN `sotorrent-org.2020_11_12.PostTagsTemp` temp
ON tags.TagName = temp.Tag;

=> `sotorrent-org.2020_11_12.PostTags`
