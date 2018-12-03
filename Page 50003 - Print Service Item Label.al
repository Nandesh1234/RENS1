page 50003 "Print Service Item Label INE"
{
    // version RENS1844.001

    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Print Service Item Label';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Customer No."; CustomerNo)
                {
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = TRUE;
                    TableRelation = Customer;
                    ApplicationArea = All;
                }
                field("No of Items"; NoofLabels)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Service Item")
            {
                Promoted = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CreateServiceItem;
                end;
            }
            action("Print Packing Slip")
            {
                Promoted = true;
                ApplicationArea = All;
            }
        }
    }

    var
        CustomerNo: Code[10];
        NoofLabels: Integer;

    local procedure CreateServiceItem()
    var
        recItem: Record "Item";
        recServiceItem: Record "Service Item";
        Customer: Record "Customer";
        i: Integer;
        ServiceItemStartNo: Code[20];
        ServiceItemEndNo: Code[20];
    begin

        Customer.GET(CustomerNo);
        IF NoofLabels = 0 THEN
            ERROR('Please enter No of labels');

        FOR i := 1 TO NoofLabels DO BEGIN

            recServiceItem.INIT;
            recServiceItem.INSERT(TRUE);
            recServiceItem.VALIDATE("Customer No.", CustomerNo);
            recServiceItem.MODIFY(TRUE);

            IF i = 1 THEN
                ServiceItemStartNo := recServiceItem."No.";

            IF i = NoofLabels THEN
                ServiceItemEndNo := recServiceItem."No.";

            CLEAR(recItem);
            CLEAR(recServiceItem);
        END;
        COMMIT;
        recServiceItem.RESET;
        recServiceItem.SETRANGE("No.", ServiceItemStartNo, ServiceItemEndNo);
        REPORT.RUNMODAL(50000, TRUE, TRUE, recServiceItem);
        CLEAR(CustomerNo);
        CLEAR(NoofLabels);
    end;
}

