namespace HelgesenConsulting.NoSeriesManager;

permissionset 70574000 "NSMGR NSHLG, VIEW"
{
    Assignable = true;
    Caption = 'No Series Manager - View';

    Permissions =
        tabledata "No. Series Pattern NSHLG" = R,
        table "No. Series Pattern NSHLG" = X;
}
