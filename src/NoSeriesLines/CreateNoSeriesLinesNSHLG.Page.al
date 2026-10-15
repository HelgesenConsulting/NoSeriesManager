namespace HelgesenConsulting.NoSeriesManager;

page 70574000 "Create No. Series Lines NSHLG"
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
                field("Series Code"; Rec."No. Series Code")
                {
                    Caption = 'No. Series Code';
                    Editable = false;
                }
                field(Instructions; this.InstructionalTextTxt)
                {
                    ShowCaption = false;
                    MultiLine = true;
                }
                field(Pattern; Rec.Pattern)
                {
                    Caption = 'Pattern';
                    ShowMandatory = true;
                }
                field(Cadence; Rec.Cadence)
                {
                    Caption = 'Cadence';
                    ShowMandatory = true;
                }
                field("Start Date"; this.StartDate)
                {
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the date that the first line starts on. Lines are created for one year from this date.';
                    ShowMandatory = true;
                }
                field("Increment-by No."; Rec."Increment-by No.")
                {
                    Caption = 'Increment-by No.';
                }
                field("Warning No. Offset"; Rec."Warning No. Offset")
                {
                    Caption = 'Warning No. Offset';
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
        LinesCreated := CreateNoSeriesLines.SaveAndCreateLines(Rec, this.StartDate);
        Message(this.LinesCreatedMsg, LinesCreated);
        exit(true);
    end;

    procedure SetSetup(NoSeriesPattern: Record "No. Series Pattern NSHLG"; NewStartDate: Date)
    begin
        Rec := NoSeriesPattern;
        Rec.Insert(false);
        this.StartDate := NewStartDate;
    end;

    var
        StartDate: Date;
        LinesCreatedMsg: Label '%1 number series line(s) were created.', Comment = '%1 = number of lines created';
        InstructionalTextTxt: Label 'Use the following tokens in the pattern:\  CC = Century, YY = Year\  MM = Month\  DD = Day\  Q = Quarter';
}
