namespace HelgesenConsulting.NoSeriesManager;

enum 70574000 "Series Line Cadence NSHLG"
{
    Extensible = false;
    Caption = 'Series Line Cadence';

    value(1; Day)
    {
        Caption = 'Day';
    }
    value(2; Week)
    {
        Caption = 'Week';
    }
    value(3; Month)
    {
        Caption = 'Month';
    }
    value(4; Quarter)
    {
        Caption = 'Quarter';
    }
    value(5; Year)
    {
        Caption = 'Year';
    }
}
