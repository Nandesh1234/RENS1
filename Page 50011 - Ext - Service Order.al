pageextension 50011 "Service Order Pg. Ext. INE" extends "Service Order"
{
    // version NAVW113.00,RENS1844.001

    layout
    {
        addafter("Contact No.")
        {
            field("Order Status"; "Order Status INE")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
}

