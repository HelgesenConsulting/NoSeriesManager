# No. Series Manager – User Guide

## Who this is for

Finance and system administrators who maintain number series in Business Central and want period-based series (per week, month, quarter or year) without creating each line by hand.

## Before you start

- You need the permission set **NSMGR NSHLG, EDIT**.
- The number series must already exist in **No. Series**.

## Create lines for a year

1. Search for **No. Series** and open it.
2. Select the number series you want to maintain.
3. Choose **Processing > Create No. Series Lines**.
4. Fill in the dialog:
   - **Pattern** – for example `CCYY-10000` or `INV-YYMM-0001`. The pattern must end with the starting number.
   - **Cadence** – Day, Week, Month, Quarter or Year. This decides how many lines are created.
   - **Start Date** – the first line starts on this date. Lines are created for one year from it.
   - **Increment-by No.** – the step between numbers. Leave at 1 for consecutive numbers.
   - **Warning No. Offset** – how many numbers before the ending number a warning is given. Leave at 0 for no warning.
5. Choose **OK**.

A message tells you how many lines were created. Open **Lines** on the number series to review them.

The same action is available on the **No. Series Lines** page.

## Examples

| Goal | Pattern | Cadence | Result per line |
| --- | --- | --- | --- |
| One series per year | `CCYY-10000` | Year | `2027-10000` … `2027-99999` |
| One series per month | `INV-YYMM-0001` | Month | `INV-2701-0001` … `INV-2701-9999` |
| One series per quarter | `YYQ-1000` | Quarter | `271-1000` … `271-9999` |
| One series per week | `YYWW-001` | Week | `2701-001` … `2701-999` |

## Good to know

- **Re-running is safe.** A period that already has a line, with the same starting date or the same starting number, is skipped. Existing lines are not changed.
- **The setup is remembered** per number series and prefilled the next time.
- **Default start date** is 1 January of the first year that has no lines yet.
- **Week numbers** are calculated from the start date of each period.

## Troubleshooting

| Message | What to do |
| --- | --- |
| You must specify a start date. | Fill in **Start Date**. |
| The pattern %1 must end with the starting number… | End the pattern with digits, e.g. `CCYY-10000`. |
| The pattern %1 does not give every period its own numbers… | Add tokens (`YY`, `MM`, `DD`, `Q`, `WW`) so each period gets a different prefix. |
| The numeric part at the end of the pattern cannot be longer than 18 digits. | Shorten the number part. |
| The resulting number is longer than the maximum of 20 characters. | Shorten the pattern. |
| The warning number offset is larger than the range of the starting number. | Lower **Warning No. Offset**. |
