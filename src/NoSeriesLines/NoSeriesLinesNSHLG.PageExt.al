namespace HelgesenConsulting.NoSeriesManager;

using Microsoft.Foundation.NoSeries;

pageextension 70574001 "No. Series Lines NSHLG" extends "No. Series Lines"
{
    actions
    {
        addlast(Processing)
        {
            action("Create No. Series Lines NSHLG")
            {
                ApplicationArea = All;
                Caption = 'Create No. Series Lines';
                ToolTip = 'Create number series lines for a year from a pattern, such as CCYY-10000, and a cadence.';
                Image = NumberGroup;
                Ellipsis = true;

                trigger OnAction()
                var
                    CreateNoSeriesLines: Codeunit "Create No. Series Lines NSHLG";
                begin
                    Rec.TestField("Series Code");
                    CreateNoSeriesLines.RunDialog(Rec."Series Code");
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
