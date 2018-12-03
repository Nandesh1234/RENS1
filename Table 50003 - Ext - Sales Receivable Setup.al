tableextension 50003 "SR Setup Tb. Ext. INE" extends "Sales & Receivables Setup"
{
    // version NAVW113.00,NAVDK13.00,RENS1844.001

    fields
    {
        field(50000; "Item No. for Truck Route INE"; Code[20])
        {
            Caption = 'Item No. for Truck Route';
            DataClassification = ToBeClassified;
            TableRelation = "Item";
        }
        field(50001; "To EmailID Truck Notification INE"; Text[100])
        {
            Caption = 'To EmailID Truck Notification';
            DataClassification = ToBeClassified;
        }
    }
}

