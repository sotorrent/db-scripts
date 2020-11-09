SELECT temp.PostId AS PostId, tags.Id AS TagId
FROM `sotorrent-org.2020_08_31.Tags` tags
JOIN `sotorrent-org.2020_08_31.PostTagsTemp` temp
ON tags.TagName = temp.Tag;

=> `sotorrent-org.2020_06_31.PostTags`
