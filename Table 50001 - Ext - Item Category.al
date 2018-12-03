tableextension 50001 "Item Category Tb. Ext. INE" extends "Item Category"
{
    // version NAVW113.00,RENS1844.001

    fields
    {
        field(50000; "Category Type INE"; Option)
        {
            Caption = 'Category Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Carpet,Furniture';
            OptionMembers = " ",Carpet,Furniture;
        }
    }
}

