page 50001 "Registration Service Lines INE"
{
    // version RENS1844.001

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Service line";
    Caption = 'Service Lines';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    QuickEntry = false;

                }
                field("Service Item No."; "Service Item No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    QuickEntry = false;
                }

                field("Item No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Item Variant"; "Variant Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    QuickEntry = false;
                }

                field(Circle; "Circle INE")
                {
                    ApplicationArea = All;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Size X"; "Size X INE")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    trigger Onvalidate()
                    begin
                        IF "Circle INE" THEN begin
                            validate("Qty. to Consume", 0);
                            VALIDATE(Quantity, 3.14 * ("Size X INE" / 2) * ("Size X INE" / 2));
                            validate("Qty. to Consume", 3.14 * ("Size X INE" / 2) * ("Size X INE" / 2));
                        end ELSE begin
                            validate("Qty. to Consume", 0);
                            VALIDATE(Quantity, "Size X INE" * "Size Y INE");
                            validate("Qty. to Consume", "Size X INE" * "Size Y INE");
                        end;
                    end;
                }
                field("Size Y"; "Size Y INE")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    trigger Onvalidate()
                    begin
                        IF "Circle INE" THEN begin
                            validate("Qty. to Consume", 0);
                            VALIDATE(Quantity, 3.14 * ("Size X INE" / 2) * ("Size X INE" / 2));
                            validate("Qty. to Consume", 3.14 * ("Size X INE" / 2) * ("Size X INE" / 2));
                        end ELSE begin
                            validate("Qty. to Consume", 0);
                            VALIDATE(Quantity, "Size X INE" * "Size Y INE");
                            validate("Qty. to Consume", "Size X INE" * "Size Y INE");
                        end;
                    end;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    trigger onvalidate()
                    begin
                        VALIDATE("Qty. to Consume", Quantity);
                    end;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Job Code"; "Job No.")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }

                field("Job Task"; "Job Task No.")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }

                field("Fixed Price"; "Fixed Price INE")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    trigger onvalidate()
                    begin
                        VALIDATE("Unit Price", "Fixed Price INE");
                    end;
                }
            }
        }
    }

    actions
    {
    }
    procedure FilterData(ServiceOrderNo: code[20]; ServiceLineNo: Integer)
    begin
        FILTERGROUP(2);
        SETRANGE("Document No.", ServiceOrderNo);
        //SETRANGE("Line No.", ServiceLineNo);
        FILTERGROUP(0);
        CurrPage.UPDATE;
    end;
}

