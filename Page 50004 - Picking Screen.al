page 50004 "Picking Screen INE"
{
    // version RENS1844.001

    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Picking Screen';

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

                    trigger OnValidate()
                    begin
                        CreateSalesOrder(OrderNo);
                        CurrPage.SalesPickLine.PAGE.FilterLines(OrderNo);
                        CurrPage.UPDATE;
                    end;
                }
            }
            part(SalesPickLine; 50005)
            {
                ApplicationArea = All;
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


            action("Send Mail ")
            {
                ApplicationArea = ALl;
                Promoted = True;

                trigger OnAction()
                var
                    RenserietFncs: Codeunit "Renseriet Functions INE";
                begin
                    RenserietFncs.SendEmail();
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.SalesPickLine.PAGE.FilterLines('');
        CurrPage.UPDATE;
    end;

    var
        CustomerNo: Code[20];
        OrderNo: Code[20];

    local procedure CreateSalesOrder(var OrderNo: Code[20])
    var
        Item: Record "Item";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record "Customer";
        LineNo: Integer;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SRSetup: Record "Sales & Receivables Setup";
    begin

        IF CustomerNo = '' THEN
            EXIT;

        Customer.GET(CustomerNo);

        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE("Order Date", WORKDATE);
        SalesHeader.SETRANGE("Sell-to Customer No.", CustomerNo);
        IF NOT SalesHeader.FINDFIRST THEN BEGIN
            SalesHeader.INIT;
            SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.INSERT(TRUE);
            SalesHeader.VALIDATE("Sell-to Customer No.", CustomerNo);
            SalesHeader.MODIFY(TRUE);
        END;

        OrderNo := SalesHeader."No.";
        IF SalesHeader.Status = SalesHeader.Status::Released THEN
            ReleaseSalesDocument.Reopen(SalesHeader);

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDLAST THEN
            LineNo := SalesLine."Line No.";

        SalesLine.INIT;
        SalesLine.VALIDATE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.VALIDATE("Document No.", SalesHeader."No.");
        SalesLine.VALIDATE("Line No.", LineNo + 10000);
        SalesLine.INSERT(TRUE);

        SRSetup.GET;

        SalesLine.VALIDATE(Type, SalesLine.Type::Item);
        SalesLine.VALIDATE("No.", SRSetup."Item No. for Truck Route INE");
        SalesLine.MODIFY(TRUE);
    end;
}

