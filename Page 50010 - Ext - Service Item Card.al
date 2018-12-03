pageextension 50010 "Service Item Card Pg. Ext. INE" extends "Service Item Card"
{
    // version NAVW113.00,RENS1844.001

    layout
    {
        addafter("Installation Date")
        {
            group("Custom Fields")
            {
                Caption = 'Custom Fields';
                field("Size category"; "Size Category INE")
                {
                    ApplicationArea = all;
                }
                field("Size X"; "Size X INE")
                {
                    ApplicationArea = all;
                }
                field("Size Y"; "Size Y INE")
                {
                    ApplicationArea = all;
                }
                field("Internal Service Tag"; "Internal Service Tag INE")
                {
                    ApplicationArea = all;
                }
                field("Due Date"; "Due Date INE")
                {
                    ApplicationArea = all;
                }
                field("Service Item Status"; "Service Item Status INE")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Memo; "Memo INE")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

