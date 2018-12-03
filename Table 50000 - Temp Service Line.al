table 50000 "Temp Service Line INE"
{
    // version RENS1844.001,RENS1844.001
    Caption = 'Temp Service Line';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Service Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Item";
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(4; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Circle; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Size X"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Size Y"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Job Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(9; "Assigned User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(11; "Fixed Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Item Variant"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Item No. Service"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(15; Memo; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Customer No.")
        {
        }
    }

    fieldgroups
    {
    }
}

