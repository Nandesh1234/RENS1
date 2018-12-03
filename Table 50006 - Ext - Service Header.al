tableextension 50006 "Service Header Tb. Ext. INE" extends "Service Header"
{
    // version NAVW113.00,NAVDK13.00,RENS1844.001

    fields
    {
        field(50000; "Order Status INE"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Registered,Packed';
            OptionMembers = " ",Registered,Packed;
            Caption = 'Order Status';
        }
    }
}

