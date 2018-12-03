pageextension 50012 "Service Orders Pg. Ext. INE" extends "Service Orders"
{
    // version NAVW113.00,RENS1844.001

    layout
    {
        addafter("Order Time")
        {
            field("Order Status"; "Order Status INE")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}

