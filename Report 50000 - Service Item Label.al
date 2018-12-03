report 50000 "Service Item Label"
{
    // version RENS1844.001

    DefaultLayout = Word;
    WordLayout = './Service Item Label.docx';
    PDFFontEmbedding = Yes;
    UseRequestPage = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Service Item"; "Service Item")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING (Number);
                column(PrintDate; CURRENTDATETIME)
                {
                }
                column(ItemNo; "Service Item"."No.")
                {
                }
                column(OutputNo; OutputNo)
                {
                }
                column(CustomerNo; "Service Item"."Customer No.")
                {
                }
                column(CustName; Customer.Name)
                {
                }
                column(CustAddress; Customer.Address)
                {
                }
                column(CustAddress2; Customer."Address 2")
                {
                }
                column(CustCity; Customer.City)
                {
                }
                column(CustPostCode; Customer."Post Code")
                {
                }
                column(CustPhoneNo; Customer."Phone No.")
                {
                }
                column(ItemBarcode; ItemBarcode)
                {
                }
                column(Memo; "Service Item"."Memo INE")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    IF Number > 1 THEN BEGIN
                        OutputNo := OutputNo + 1;
                    END;


                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Customer.GET("Service Item"."Customer No.");

                ItemBarcode := '*' + "Service Item"."No." + '*';
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Advanced;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
    end;

    var
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        Customer: Record "Customer";
        ItemBarcode: Code[30];

    local procedure GETDATE(pDate: Date): Text
    var
        Day: Integer;
    begin
        Day := DATE2DMY(pDate, 1);
        IF STRLEN(FORMAT(Day)) = 1 THEN
            EXIT('0' + FORMAT(Day))
        ELSE
            EXIT(FORMAT(Day));
    end;

    local procedure GETMONTH(pDate: Date): Text
    var
        Month: Integer;
    begin
        Month := DATE2DMY(pDate, 2);
        IF STRLEN(FORMAT(Month)) = 1 THEN
            EXIT('0' + FORMAT(Month))
        ELSE
            EXIT(FORMAT(Month));
    end;

    local procedure GETYEAR(pdate: Date): Text
    var
        Year: Integer;
    begin
        Year := DATE2DMY(pdate, 3);
        EXIT(COPYSTR(FORMAT(Year), 3, 2));
    end;
}

