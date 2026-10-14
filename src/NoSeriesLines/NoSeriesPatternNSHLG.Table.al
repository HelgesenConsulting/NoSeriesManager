namespace HelgesenConsulting.NoSeriesManager;

using Microsoft.Foundation.NoSeries;

table 50001 "No. Series Pattern NSHLG"
{
    Caption = 'No. Series Pattern';
    DataClassification = CustomerContent;
    AllowInCustomizations = AsReadWrite;

    fields
    {
        field(1; "Series Code"; Code[20])
        {
            Caption = 'Series Code';
            ToolTip = 'Specifies the number series that the pattern belongs to.';
            TableRelation = "No. Series";
        }
        field(10; Pattern; Code[20])
        {
            Caption = 'Pattern';
            ToolTip = 'Specifies the number pattern. Use CC for century, YY for year, MM for month, DD for day, Q for quarter and WW for week number, followed by the starting number, for example CCYY-10000.';
        }
        field(20; Cadence; Enum "Series Line Cadence NSHLG")
        {
            Caption = 'Cadence';
            ToolTip = 'Specifies how often a new number series line is created.';
        }
        field(30; "Increment-by No."; Integer)
        {
            Caption = 'Increment-by No.';
            ToolTip = 'Specifies the number to increment by when a new number is assigned from the number series.';
            InitValue = 1;
            MinValue = 1;
        }
        field(40; "Warning No. Offset"; Integer)
        {
            Caption = 'Warning No. Offset';
            ToolTip = 'Specifies how many numbers before the ending number a warning is given. Leave at 0 for no warning number.';
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "Series Code")
        {
            Clustered = true;
        }
    }
}
