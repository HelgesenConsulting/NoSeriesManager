namespace HelgesenConsulting.NoSeriesManager;

permissionset 70574000 "NSMGR NSHLG, VIEW"
{
    Assignable = true;
    Caption = 'No Series Manager - View', MaxLength = 30;

    Permissions =
        table "No. Series Pattern NSHLG" = X,
        tabledata "No. Series Pattern NSHLG" = R;
}
