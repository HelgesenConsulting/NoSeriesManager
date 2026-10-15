# Changelog

All notable changes to No. Series Manager are documented here. Format based on [Keep a Changelog](https://keepachangelog.com/).

## [0.0.0.1] – 2026-10-14

### Added

- Pattern-based creation of No. Series Lines with cadence Day, Week, Month, Quarter or Year.
- Pattern tokens `CC`, `YY`, `MM`, `DD`, `WW` and `Q`.
- Table **No. Series Pattern** that remembers the setup per number series.
- Action **Create No. Series Lines** on **No. Series** and **No. Series Lines**.
- Validation of start date, number width, total length, warning offset and prefix uniqueness.
- Permission sets **NSMGR NSHLG, VIEW** and **NSMGR NSHLG, EDIT**.
- Translations: en-US, en-GB, da-DK, de-DE, nb-NO, sv-SE.

### Changed

- Objects moved to the AppSource ID range 70574000–70574009.
- Code cop and analyzer cleanup; field captions aligned with field names.
