pageextension 50008 "SR Setup Pg. Ext. INE" extends "Sales & Receivables Setup"
{
    // version NAVW113.00,RENS1844.001

    layout
    {
        addafter("Write-in Product No.")
        {
            field("Item No. for Truck Route"; "Item No. for Truck Route INE")
            {
                ApplicationArea = All;
            }
            field("To EmailID Truck Notification"; "To EmailID Truck Notification INE")
            {
                ApplicationArea = All;
            }
        }
    }
}

