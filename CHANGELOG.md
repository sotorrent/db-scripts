# Changelog
All notable changes to the SOTorrent dataset project will be documented in this file.

---

## [Upcoming]

* Extract language information from Stack Snippets and link individual snippets to their predecessors
* Add non-generated comments (`PostHistory.Comment`) to table `PostVersion` 

## [2019-09-23] - First release based on SO data dump 2019-09-04
* Automate execution of SQL scripts
* Add column `MostRecentVersion` to table `TitleVersion`
* Add table `StackSnippetVersion`
* Helper table `Threads` is now officially part of SOTorrent 

## [2019-06-21] - First release based on SO data dump 2019-06-03

* Improve matching of very short post blocks (containing only one token)
* Add table `VoteType` (see [this](https://github.com/sotorrent/db-scripts/issues/17) issue on GitHub)
* Automate execution of BigQuery scripts

## [2019-03-17] - First release based on SO data dump 2019-03-04

* Update to Stack Overflow data dump 2019-03-04
* Update GitHub references to 2019-03-29 (according to BigQuery table info)
* Improve detection of HTML code blocks
* Improve detection of comment links (links containing a query string, such as `https://stackoverflow.com/questions/28705447/is-there-a-java-method-that-fills-a-list-by-calling-a-function-many-times/28705651?noredirect=1#comment45733057_28705651`, are now correctly handled)
* Update regular expression used to extract Stack Overflow links from GitHub files, correctly handle multiple Stack Overflow links per source code line (previously only the first match in each line was extracted)
* Table `PostReferenceGH` now only contains links pointing to a valid `PostId` or `CommentId`, remove column `PostTypeId` (which was derived from links and was thus sometimes wrong) and previously introduced id 99 for comments
* New column `GHMatches.PostIds` that contains a space-separated list of post ids found in the matched line
* Add new columns `PostVersion.MostRecentVersion` and `PostBlockVersion.MostRecentVersion` that make it easier to analyze only the most recent version of a post/post block
* Update to MySQL 8.0
* Switch to 7z for data compression

## [2018-12-09] - Third release for MSR Mining Challenge 2019, based on SO data dump 2018-12-02

* Update to Stack Overflow data dump 2018-12-02
* Changes to table `PostReferenceGH`:
  * Improve Stack Overflow URL extraction from source code files in BigQuery GitHub dataset
  * Stack Overflow links are now normalized to "https" instead of the "http" links
  * Comment links are now distinguished from question links:
    * Add new post type "Comment" with post type id `99`
    * Add new column `CommentId` (`null` for question and answer links)
    * `SOUrl` now points directly to comments, not to corresponding questions 
  * Split column `RepoName` into `RepoOwner` and `RepoName`, keep complete repo name as new column `Repo`
  * Retrieved references on 2018-12-09
* New table `GHMatches` with matched source code lines containing a link to Stack Overflow questions, answers, or comments
* Improve post block predecessor matching
  * Revised matching strategy (see [this](https://arxiv.org/abs/1811.00804) paper preprint for more information)
  * New [default](https://github.com/sotorrent/posthistory-extractor/blob/5876e666e5001b5a7b9a26057358a9855f088a0a/src/org/sotorrent/posthistoryextractor/Config.java#L75) metrics and thresholds 
* Add remark to use Archive Utility on macOS to extract the dataset (see [README](https://github.com/sotorrent/db-scripts/blob/master/sotorrent/README.md) file)

## [2018-09-23] - Second release for MSR Mining Challenge 2019, based on SO data dump 2018-09-05

* Update to Stack Overflow data dump 2018-09-05
* Update `PostReferenceGH` (retrieved on 2018-09-23)

## [2018-08-28] - First release for MSR Mining Challenge 2019, based on SO data dump 2018-06-05

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
