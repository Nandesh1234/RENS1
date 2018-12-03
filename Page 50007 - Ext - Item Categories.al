pageextension 50007 "Item Categories Pg. Ext. INE" extends "Item Categories"
{
    // version NAVW113.00,RENS1844.001

    layout
    {
        addafter(Description)
        {
            field("Category Type"; "Category Type INE")
            {
                ApplicationArea = All;
            }
        }
    }
}

