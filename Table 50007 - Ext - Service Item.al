tableextension 50007 "Service Item Tb. Ext. INE" extends "Service Item"
{
    // version NAVW113.00,RENS1844.001

    fields
    {
        field(50000; "Size Category INE"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Size Category';
        }
        field(50001; "Size X INE"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Size X';
        }
        field(50002; "Size Y INE"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Size Y';
        }
        field(50003; "Internal Service Tag INE"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Service Tag';
        }
        field(50004; "Due Date INE"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';
        }
        field(50005; "Service Item Status INE"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Registered,Packed';
            OptionMembers = " ",Registered,Packed;
            Caption = 'Service Item Status';
        }
        field(50006; "Memo INE"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Memo';
        }

        field(50007; "Email Data INE"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Email Data';
        }
        field(50008; "Circle INE"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Circle';
        }
    }
}

