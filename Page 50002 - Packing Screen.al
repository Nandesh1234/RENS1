page 50002 "Packing Screen INE"
{
    // version RENS1844.001

    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Packing Screen';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Scan Service Item Label"; Input)
                {
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = TRUE;
                    TableRelation = "Service Item";
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        recServiceItem.Reset;
                        recServiceItem.SetRange("No.", Input);
                        IF recserviceitem.FindFirst THEN BEGIN

                            recServiceItem."Service Item Status INE" := recServiceItem."Service Item Status INE"::Packed;
                            recServiceItem.MODIFY;

                            recServiceItemLine.RESET;
                            recServiceItemLine.SETRANGE("Service Item No.", recServiceItem."No.");
                            recServiceItemLine.SETRANGE("Document Type", recServiceItemLine."Document Type"::Order);
                            IF recServiceItemLine.FINDFIRST THEN BEGIN
                                recServiceHeader.RESET;
                                recServiceHeader.SETRANGE("Document Type", recServiceHeader."Document Type"::Order);
                                recServiceHeader.SETRANGE("No.", recServiceItemLine."Document No.");
                                IF recServiceHeader.FINDFIRST THEN BEGIN
                                    recServiceHeader."Order Status INE" := recServiceHeader."Order Status INE"::Packed;
                                    recServiceHeader.MODIFY;
                                END;
                            END;

                            COMMIT;
                            REPORT.RUNMODAL(50000, TRUE, TRUE, recServiceItem);

                            Input := '';
                        END;

                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(links; Links)
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
            action("Print Packing Slip")
            {
                Promoted = true;
                ApplicationArea = All;
            }
        }
    }

    var
        Input: Text;
        recServiceItem: Record "Service Item";
        recServiceHeader: Record "Service Header";
        recServiceItemLine: Record "Service Item Line";
}

