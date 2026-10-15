namespace HelgesenConsulting.NoSeriesManager;

using Microsoft.Foundation.NoSeries;

pageextension 70574000 "No. Series NSHLG" extends "No. Series"
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
                    Rec.TestField(Code);
                    CreateNoSeriesLines.RunDialog(Rec.Code);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
