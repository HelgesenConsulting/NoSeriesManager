namespace HelgesenConsulting.NoSeriesManager;

permissionset 50006 "NSMGR NSHLG, VIEW"
{
    Assignable = true;
    Caption = 'No Series Manager - View';

    Permissions =
        tabledata "No. Series Pattern NSHLG" = R,
        table "No. Series Pattern NSHLG" = X;
}
