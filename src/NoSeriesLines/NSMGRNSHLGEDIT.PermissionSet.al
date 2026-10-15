namespace HelgesenConsulting.NoSeriesManager;

using Microsoft.Foundation.NoSeries;

permissionset 70574001 "NSMGR NSHLG, EDIT"
{
    Assignable = true;
    Caption = 'No Series Manager - Edit', MaxLength = 30;
    IncludedPermissionSets = "NSMGR NSHLG, VIEW";

    Permissions =
        tabledata "No. Series" = R,
        tabledata "No. Series Line" = RI,
        tabledata "No. Series Pattern NSHLG" = IMD,
        codeunit "Create No. Series Lines NSHLG" = X,
        page "Create No. Series Lines NSHLG" = X;
}
