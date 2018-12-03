tableextension 50004 "Service CM Line Tb. Ext. INE" extends "Service Cr.Memo Line"
{
    // version NAVW113.00,NAVDK13.00,RENS1844.001

    fields
    {
        field(50000; "Size category INE"; Code[20])
        {
            Caption = 'Size category';
            DataClassification = ToBeClassified;
        }
        field(50001; "Size X INE"; Decimal)
        {
            Caption = 'Size X';
            DataClassification = ToBeClassified;
        }
        field(50002; "Size Y INE"; Decimal)
        {
            Caption = 'Size Y';
            DataClassification = ToBeClassified;
        }
        field(50003; "Circle INE"; Boolean)
        {
            Caption = 'Circle';
            DataClassification = ToBeClassified;
        }
        field(50004; "Fixed Price INE"; Decimal)
        {
            Caption = 'Fixed Price';
            DataClassification = ToBeClassified;
        }
    }
}

