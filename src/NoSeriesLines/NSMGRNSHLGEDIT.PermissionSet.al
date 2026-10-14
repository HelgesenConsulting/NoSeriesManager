namespace HelgesenConsulting.NoSeriesManager;

using Microsoft.Foundation.NoSeries;

permissionset 70574001 "NSMGR NSHLG, EDIT"
{
    Assignable = true;
    Caption = 'No Series Manager - Edit';
    IncludedPermissionSets = "NSMGR NSHLG, VIEW";

    Permissions =
        tabledata "No. Series Pattern NSHLG" = IMD,
        tabledata "No. Series" = R,
        tabledata "No. Series Line" = RI,
        page "Create No. Series Lines NSHLG" = X,
        codeunit "Create No. Series Lines NSHLG" = X;
}
