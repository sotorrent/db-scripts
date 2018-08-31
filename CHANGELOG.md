# Changelog
All notable changes to the SOTorrent dataset project will be documented in this file.

---

## [2018-08-28] - Release for MSR Mining Challenge 2019, based on SO data dump 2018-06-05

* Improve URL extraction (e.g., exclude matches in Markdown inline code, exclude invalid links)

## [2018-07-31] - Second release based on SO data dump 2018-06-05

* Add new columns `FragmentIdentifier` and `Query` to tables `PostVersionUrl` and `CommentUrl`
* Add new column `LinkType` to tables `PostVersionUrl` and `CommentUrl` (e.g., inline Markdown link, bare link, etc.)
* Add new column `LinkPosition` to tables `PostVersionUrl` and `CommentUrl` (beginning, middle, end of post/comment, or "link only" if a comment/post consists only of a URL)
* Add new column `FullMatch` to tables `PostVersionUrl` and `CommentUrl`

## [2018-06-17] - First release based on SO data dump 2018-06-05

* Update to Stack Overflow data dump 2018-06-05
* Case-insensitive extraction of URL components

## [2018-05-04] - Second release based on SO data dump 2018-03-13

* Add new columns `Protocol`, `CompleteDomain`, and `RootDomain` to table `PostVersionUrl`
* Add new columns `LocalId`, `PredLocalId`, and `PredPostHistoryId` to table `PostBlockDiff` (enables retrieval of diffs according to position in post without requiring a join)
* Add new columns `PredLocalId`, `PredPostHistoryId`, `RootLocalId`, and `RootPostHistoryId` to table `PostBlockVersion` (easier detection of position changes and easier retrieval of post block lifespans)
* Rename column `RootPostBlockId` of table `PostBlockVersion` to `RootPostBlockVersionId` and column `PredPostBlockId` to `PredPostBlockVersionId` (reason: consistent naming)
* Remove column `PostVersionId` from table `PostBlockVersion` (reason: the stable `PostHistoryId` should be used instead)
* Add new table `CommentUrl`
* Add new table `TitleVersion`

---

## [2018-03-28] - First release based on SO data dump 2018-03-13

* Update to Stack Overflow data dump 2018-03-13
* `Comments.UserDisplayName`:  `VARCHAR(30)` → `VARCHAR(40)` (unify the type of all display name columns) 
* Create indices for all user display name columns
* Add table `PostHistoryType` (see column `Revision` [here](http://data.stackexchange.com/stackoverflow/query/36599/show-all-types)) and add column `PostHistoryTypeId` to table `PostVersion`
* Add auto-generated primary key `Id` to table `PostReferenceGH`
* All tables from the offical Stack Overflow dump are now available in the BigQuery version of the dataset

---

## [2018-02-16] - Release for MSR paper camera-ready

* Schema files for importing SOTorrent into Google BigQuery ([db-scripts](http://github.com/sotorrent/db-scripts))
*  Improve filename regex ([db-scripts](http://github.com/sotorrent/db-scripts))
    * Prevent matching of directory names starting with "." in table `PostReferenceGH` (for example `.history/17/10db4490e45300171a8a828d7b324fa2`)
*  Order post versions according to `CreationDate` instead of `PostHistoryId` ([so-posthistory-extractor](http://github.com/sotorrent/so-posthistory-extractor/) and [db-scripts](http://github.com/sotorrent/db-scripts))
    * In the SOTorrent 2018-01-18 dataset, 283 posts created in 2008/2009 were not ordered chronologically (see "broken_entries" in "analysis_postversion_edit_timespan.R").
    * Thus, we now order post versions according to their `CreationDate` (instead of using the `PostHistoryId`).
    * Updated database schema and class `PostVersion to include new member variable `CreationDate`.
* Fixed import and export scripts ([db-scripts](http://github.com/sotorrent/db-scripts))
* Replaced newline character in GitHub path, which was present in two rows of table PostReferenceGH ([db-scripts](http://github.com/sotorrent/db-scripts))

---

## [Obsolete]

* `UserId`/`OwnerUserId` is `null` in some cases. Then, the  `UserDisplayName` has to be employed to identify users. This applies for tables `Comments`, `PostHistory`, `Posts`. Idea: Find the corresponding Ids using `UserDisplayName` and table `Users`, replace the `null` values, and add foreign key constraints, which is currently not possible.
  **UPDATE 2018-03-13:**  533,378 of 5,765,510 `UserDisplayNames` are not unique, thus the approach described above does not work. 

---

The format of this file is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).
