# Changelog
All notable changes to the SOTorrent dataset project will be documented in this file.

---

## [2018-02-16] - Release for MSR camera-ready

### Changed
*  Improve filename regex ([db-scripts](http://github.com/sotorrent/db-scripts))
    * Prevent matching of directory names starting with "." in table `PostReferenceGH` (for example `.history/17/10db4490e45300171a8a828d7b324fa2`)

### Fixed
*  Order post versions according to `CreationDate` instead of `PostHistoryId` ([so-posthistory-extractor](http://github.com/sotorrent/so-posthistory-extractor/) and [db-scripts](http://github.com/sotorrent/db-scripts))
    * In the SOTorrent 2018-01-18 dataset, 283 posts created in 2008/2009 were not ordered chronologically (see "broken_entries" in "analysis_postversion_edit_timespan.R").
    * Thus, we now order post versions according to their `CreationDate` (instead of using the `PostHistoryId`).
    * Updated database schema and class `PostVersion to include new member variable `CreationDate`.
* Fixed import and export scripts ([db-scripts](http://github.com/sotorrent/db-scripts))

---

The format of this file is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).
