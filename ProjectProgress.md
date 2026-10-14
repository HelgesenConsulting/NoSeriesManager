# Project Progress — No Series Manager

## Build-a-Feature
One row per object asked for, in start order, plus the intake, the package, and the review (Ops § Build-a-Feature).

| Row | Object | Type | ID | Stage | Status | Shipped in |
|---|---|---|---|---|---|---|
| F00 | Intake | — | — | — | Completed | — |
| F01 | Series Line Cadence NSHLG | Enum | 50000 | Compiled | Completed | |
| F02 | No. Series Pattern NSHLG | Table | 50001 | Compiled | Completed | |
| F03 | Create No. Series Lines NSHLG | Codeunit | 50002 | Compiled | Completed | |
| F04 | Create No. Series Lines NSHLG | Page (Dialog) | 50003 | Compiled | Completed | |
| F05 | No. Series NSHLG / No. Series Lines NSHLG | Page Extension | 50004, 50005 | Compiled | Completed | |
| F06 | NSMGR NSHLG, VIEW / EDIT | Permission Set | 50006, 50007 | Compiled | Completed | |

## Usage and cost
Measured at every object's close by the `usage` script, never by hand. One row per model that ran.

### Claude Code — tokens by type
From Claude Code's session transcripts.
| Step | Model(s) | Input | Output | Cache write | Cache read | Cost (USD) | Elapsed | Turns | Decisions | Sub-agent calls | Senior AL dev est. (h) | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F00 | claude-sonnet-5-5 | 18 | 3,233 | 11,546 | 1,041,519 | price unknown | 0h 18m | 0 | 1 | 0 | | 9 requests |
| F03 | claude-sonnet-5-5 | 8 | 2,987 | 10,990 | 500,537 | price unknown | 0h 02m | 0 | 1 | 0 | | 4 requests |
| F04 | claude-sonnet-5-5 | 6 | 3,726 | 4,807 | 404,748 | price unknown | 0h 02m | 0 | 1 | 0 | | 3 requests |
| F05 | claude-sonnet-5-5 | 10 | 19,821 | 16,165 | 720,585 | price unknown | 0h 02m | 0 | 0 | 0 | | 5 requests |
| F06 | claude-sonnet-5-5 | 34 | 6,868 | 20,535 | 2,855,456 | price unknown | 0h 02m | 0 | 0 | 0 | | 17 requests |
| Unattributed | claude-sonnet-5-5 | 76 | 13,284 | 84,363 | 3,042,758 | price unknown | n/a | 7 | 8 | 0 | | 38 requests |
| **Total** | | 152 | 49,919 | 148,406 | 8,565,603 | unpriced | | | | | | |

---
*Asking "Where are we?" gets a direct answer from this file.*
