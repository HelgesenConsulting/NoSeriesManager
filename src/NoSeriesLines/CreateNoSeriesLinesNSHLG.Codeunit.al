namespace HelgesenConsulting.NoSeriesManager;

using Microsoft.Foundation.NoSeries;

codeunit 50002 "Create No. Series Lines NSHLG"
{
    procedure RunDialog(SeriesCode: Code[20])
    var
        NoSeriesPattern: Record "No. Series Pattern NSHLG";
        CreateNoSeriesLines: Page "Create No. Series Lines NSHLG";
    begin
        if not NoSeriesPattern.Get(SeriesCode) then begin
            NoSeriesPattern.Init();
            NoSeriesPattern."Series Code" := SeriesCode;
            NoSeriesPattern.Cadence := NoSeriesPattern.Cadence::Month;
        end;
        CreateNoSeriesLines.SetSetup(NoSeriesPattern, this.GetDefaultStartDate(SeriesCode));
        CreateNoSeriesLines.RunModal();
    end;

    local procedure GetDefaultStartDate(SeriesCode: Code[20]): Date
    var
        NoSeriesLine: Record "No. Series Line";
        YearNo: Integer;
    begin
        YearNo := Date2DMY(WorkDate(), 3);
        NoSeriesLine.SetRange("Series Code", SeriesCode);
        repeat
            NoSeriesLine.SetRange("Starting Date", DMY2Date(1, 1, YearNo), DMY2Date(31, 12, YearNo));
            if NoSeriesLine.IsEmpty() then
                exit(DMY2Date(1, 1, YearNo));
            YearNo += 1;
        until YearNo >= 9999;
        exit(DMY2Date(1, 1, Date2DMY(WorkDate(), 3)));
    end;

    internal procedure SaveAndCreateLines(NoSeriesPattern: Record "No. Series Pattern NSHLG"; StartDate: Date): Integer
    var
        SavedPattern: Record "No. Series Pattern NSHLG";
        PeriodStarts: List of [Date];
        Prefixes: List of [Text];
        NumberPart: Text;
        PrefixPattern: Text;
        Prefix: Text;
        Width: Integer;
        StartNumber: Decimal;
        EndNumber: Decimal;
        WarningNumber: Decimal;
        i: Integer;
        StartDateRequiredErr: Label 'You must specify a start date.';
        NumberPartTooLongErr: Label 'The numeric part at the end of the pattern cannot be longer than %1 digits.', Comment = '%1 = maximum number of digits';
        PatternTooLongErr: Label 'The resulting number is longer than the maximum of %1 characters.', Comment = '%1 = maximum length';
        WarningOffsetTooLargeErr: Label 'The warning number offset is larger than the range of the starting number.';
        NotUniqueErr: Label 'The pattern %1 does not give every period its own numbers: the period starting %2 (cadence %3) produces the same prefix as an earlier period. Add tokens such as YY, MM, DD, Q or WW.', Comment = '%1 = the pattern, %2 = start date of the period, %3 = cadence';
    begin
        NoSeriesPattern.TestField("Series Code");
        NoSeriesPattern.TestField(Pattern);
        NoSeriesPattern.TestField(Cadence);
        if StartDate = 0D then
            Error(StartDateRequiredErr);

        this.SplitPattern(NoSeriesPattern.Pattern, PrefixPattern, NumberPart);
        Width := StrLen(NumberPart);
        if Width > MaxNumberWidth() then
            Error(NumberPartTooLongErr, MaxNumberWidth());
        Evaluate(StartNumber, NumberPart);
        EndNumber := Power(10, Width) - 1;
        if NoSeriesPattern."Warning No. Offset" > 0 then begin
            WarningNumber := EndNumber - NoSeriesPattern."Warning No. Offset";
            if WarningNumber < StartNumber then
                Error(WarningOffsetTooLargeErr);
        end;

        this.GetPeriodStarts(StartDate, NoSeriesPattern.Cadence, PeriodStarts);
        for i := 1 to PeriodStarts.Count() do begin
            Prefix := this.ExpandTokens(PrefixPattern, PeriodStarts.Get(i));
            if StrLen(Prefix) + Width > MaxStrLen(SavedPattern.Pattern) then
                Error(PatternTooLongErr, MaxStrLen(SavedPattern.Pattern));
            if Prefixes.Contains(Prefix) then
                Error(NotUniqueErr, NoSeriesPattern.Pattern, Format(PeriodStarts.Get(i)), Format(NoSeriesPattern.Cadence));
            Prefixes.Add(Prefix);
        end;

        if SavedPattern.Get(NoSeriesPattern."Series Code") then begin
            SavedPattern.TransferFields(NoSeriesPattern, false);
            SavedPattern.Modify(true);
        end else begin
            SavedPattern := NoSeriesPattern;
            SavedPattern.Insert(true);
        end;

        exit(this.InsertLines(NoSeriesPattern, PeriodStarts, Prefixes, NumberPart, Width, EndNumber, WarningNumber));
    end;

    local procedure InsertLines(NoSeriesPattern: Record "No. Series Pattern NSHLG"; PeriodStarts: List of [Date]; Prefixes: List of [Text]; NumberPart: Text; Width: Integer; EndNumber: Decimal; WarningNumber: Decimal): Integer
    var
        NoSeriesLine: Record "No. Series Line";
        CheckLine: Record "No. Series Line";
        StartingNo: Text;
        NextLineNo: Integer;
        Created: Integer;
        i: Integer;
    begin
        NoSeriesLine.SetRange("Series Code", NoSeriesPattern."Series Code");
        if NoSeriesLine.FindLast() then
            NextLineNo := NoSeriesLine."Line No.";

        for i := 1 to PeriodStarts.Count() do begin
            StartingNo := Prefixes.Get(i) + NumberPart;

            CheckLine.Reset();
            CheckLine.SetRange("Series Code", NoSeriesPattern."Series Code");
            CheckLine.SetRange("Starting Date", PeriodStarts.Get(i));
            if CheckLine.IsEmpty() then begin
                CheckLine.SetRange("Starting Date");
                CheckLine.SetRange("Starting No.", CopyStr(StartingNo, 1, MaxStrLen(CheckLine."Starting No.")));
                if CheckLine.IsEmpty() then begin
                    NextLineNo += 10000;
                    NoSeriesLine.Init();
                    NoSeriesLine."Series Code" := NoSeriesPattern."Series Code";
                    NoSeriesLine."Line No." := NextLineNo;
                    NoSeriesLine."Starting Date" := PeriodStarts.Get(i);
                    NoSeriesLine.Validate("Starting No.", CopyStr(StartingNo, 1, MaxStrLen(NoSeriesLine."Starting No.")));
                    NoSeriesLine.Validate("Ending No.", CopyStr(Prefixes.Get(i) + FormatNumber(EndNumber, Width), 1, MaxStrLen(NoSeriesLine."Ending No.")));
                    if NoSeriesPattern."Warning No. Offset" > 0 then
                        NoSeriesLine.Validate("Warning No.", CopyStr(Prefixes.Get(i) + FormatNumber(WarningNumber, Width), 1, MaxStrLen(NoSeriesLine."Warning No.")));
                    NoSeriesLine.Validate("Increment-by No.", NoSeriesPattern."Increment-by No.");
                    NoSeriesLine.Insert(true);
                    Created += 1;
                end;
            end;
        end;
        exit(Created);
    end;

    local procedure SplitPattern(Pattern: Text; var PrefixPattern: Text; var NumberPart: Text)
    var
        Position: Integer;
        NoNumberPartErr: Label 'The pattern %1 must end with the starting number, for example CCYY-10000.', Comment = '%1 = the pattern';
    begin
        Position := StrLen(Pattern);
        while (Position > 0) and (Pattern[Position] in ['0' .. '9']) do
            Position -= 1;
        if Position = StrLen(Pattern) then
            Error(NoNumberPartErr, Pattern);
        PrefixPattern := CopyStr(Pattern, 1, Position);
        NumberPart := CopyStr(Pattern, Position + 1);
    end;

    local procedure ExpandTokens(PrefixPattern: Text; PeriodStart: Date): Text
    var
        Result: Text;
        Token: Text;
        Position: Integer;
    begin
        Position := 1;
        while Position <= StrLen(PrefixPattern) do begin
            Token := UpperCase(CopyStr(PrefixPattern, Position, 2));
            case Token of
                'CC':
                    begin
                        Result += TwoDigits(Date2DMY(PeriodStart, 3) div 100);
                        Position += 2;
                    end;
                'YY':
                    begin
                        Result += TwoDigits(Date2DMY(PeriodStart, 3) mod 100);
                        Position += 2;
                    end;
                'MM':
                    begin
                        Result += TwoDigits(Date2DMY(PeriodStart, 2));
                        Position += 2;
                    end;
                'DD':
                    begin
                        Result += TwoDigits(Date2DMY(PeriodStart, 1));
                        Position += 2;
                    end;
                'WW':
                    begin
                        Result += TwoDigits(Date2DWY(PeriodStart, 2));
                        Position += 2;
                    end;
                else begin
                    if UpperCase(CopyStr(PrefixPattern, Position, 1)) = 'Q' then
                        Result += Format((Date2DMY(PeriodStart, 2) - 1) div 3 + 1)
                    else
                        Result += CopyStr(PrefixPattern, Position, 1);
                    Position += 1;
                end;
            end;
        end;
        exit(Result);
    end;

    local procedure GetPeriodStarts(StartDate: Date; Cadence: Enum "Series Line Cadence NSHLG"; var PeriodStarts: List of [Date])
    var
        EndDate: Date;
        PeriodStart: Date;
        Offset: Integer;
    begin
        EndDate := CalcDate('<1Y-1D>', StartDate);
        PeriodStart := StartDate;
        while PeriodStart <= EndDate do begin
            PeriodStarts.Add(PeriodStart);
            Offset += 1;
            PeriodStart := CalcDate(StepFormula(Cadence, Offset), StartDate);
        end;
    end;

    local procedure StepFormula(Cadence: Enum "Series Line Cadence NSHLG"; Offset: Integer): Text
    begin
        case Cadence of
            Cadence::Day:
                exit('<' + Format(Offset) + 'D>');
            Cadence::Week:
                exit('<' + Format(Offset) + 'W>');
            Cadence::Month:
                exit('<' + Format(Offset) + 'M>');
            Cadence::Quarter:
                exit('<' + Format(Offset * 3) + 'M>');
            Cadence::Year:
                exit('<' + Format(Offset) + 'Y>');
        end;
    end;

    local procedure TwoDigits(Value: Integer): Text
    begin
        exit(Format(Value, 0, '<Integer,2><Filler Character,0>'));
    end;

    local procedure FormatNumber(Value: Decimal; Width: Integer): Text
    begin
        exit(PadStr('', Width - StrLen(Format(Value, 0, 1)), '0') + Format(Value, 0, 1));
    end;

    local procedure MaxNumberWidth(): Integer
    begin
        exit(18);
    end;        
}
