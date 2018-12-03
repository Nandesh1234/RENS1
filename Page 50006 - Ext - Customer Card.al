pageextension 50006 "Customer Card Pg. Ext. INE" extends "Customer Card"
{
    // version NAVW113.00,RENS1844.001

    actions
    {
        addafter(SaveAsTemplate)
        {
            action("Create Job")
            {
                ApplicationArea = All;
            }
        }
    }
}

