page 50005 "Sales Pick Line INE"
{
    // version RENS1844.001

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = SORTING ("Document Type", "Document No.", "Line No.")
                      WHERE ("Document Type" = CONST (Order));
    Caption = 'Sales Pick Line';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Planned Delivery Date"; "Planned Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Outbound Whse. Handling Time"; "Outbound Whse. Handling Time")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    procedure FilterLines(OrderNo: Code[20])
    begin
        FILTERGROUP(2);
        SETRANGE("Document Type", "Document Type"::Order);
        SETRANGE("Document No.", OrderNo);
        FILTERGROUP(0);
        CurrPage.UPDATE;
    end;
}

