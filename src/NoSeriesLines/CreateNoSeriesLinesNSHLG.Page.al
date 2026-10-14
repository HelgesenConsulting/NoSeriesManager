namespace HelgesenConsulting.NoSeriesManager;

page 50003 "Create No. Series Lines NSHLG"
{
    Caption = 'Create No. Series Lines';
    PageType = StandardDialog;
    ApplicationArea = All;
    SourceTable = "No. Series Pattern NSHLG";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Series Code"; Rec."Series Code")
                {
                    Caption = 'Series Code';
                    ToolTip = 'Specifies the number series that the pattern belongs to.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Pattern; Rec.Pattern)
                {
                    Caption = 'Pattern';
                    ToolTip = 'Specifies the number pattern. Use CC for century, YY for year, MM for month, DD for day, Q for quarter and WW for week number, followed by the starting number, for example CCYY-10000.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Cadence; Rec.Cadence)
                {
                    Caption = 'Cadence';
                    ToolTip = 'Specifies how often a new number series line is created.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Start Date"; StartDate)
                {
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the date that the first line starts on. Lines are created for one year from this date.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Increment-by No."; Rec."Increment-by No.")
                {
                    Caption = 'Increment-by No.';
                    ToolTip = 'Specifies the number to increment by when a new number is assigned from the number series.';
                    ApplicationArea = All;
                }
                field("Warning No. Offset"; Rec."Warning No. Offset")
                {
                    Caption = 'Warning No. Offset';
                    ToolTip = 'Specifies how many numbers before the ending number a warning is given. Leave at 0 for no warning number.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        CreateNoSeriesLines: Codeunit "Create No. Series Lines NSHLG";
        LinesCreated: Integer;
    begin
        if CloseAction <> Action::OK then
            exit(true);
        LinesCreated := CreateNoSeriesLines.SaveAndCreateLines(Rec, StartDate);
        Message(LinesCreatedMsg, LinesCreated);
        exit(true);
    end;

    procedure SetSetup(NoSeriesPattern: Record "No. Series Pattern NSHLG"; NewStartDate: Date)
    begin
        Rec := NoSeriesPattern;
        Rec.Insert();
        StartDate := NewStartDate;
    end;

    var
        StartDate: Date;
        LinesCreatedMsg: Label '%1 number series line(s) were created.', Comment = '%1 = number of lines created';
}
