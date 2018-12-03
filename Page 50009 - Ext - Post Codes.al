pageextension 50009 "Post Codes Pg. Ext. INE" extends "Post Codes"
{
    // version NAVW113.00,RENS1844.001

    layout
    {
        addafter(County)
        {
            field(Prioritization; "Prioritization INE")
            {
                ApplicationArea = All;
            }
        }
    }
}

