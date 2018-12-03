report 50001 "Truck Route"
{
    // version RENS1844.001

    DefaultLayout = RDLC;
    RDLCLayout = './Truck Route.rdlc';
    PDFFontEmbedding = Yes;
    UseRequestPage = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING ("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Base Calendar Code";
            column(BaseCalendar; Customer."Base Calendar Code")
            {
            }
            column(BaseCalendarName; BaseCalenderDesc)
            {
            }
            column(WorkDate; PlannedDelDate)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddress; CompInfo.Address)
            {
            }
            column(CompAddress2; CompInfo."Address 2")
            {
            }
            column(CompCity; CompInfo.City)
            {
            }
            column(CompPostCode; CompInfo."Post Code")
            {
            }
            column(CompPicture; CompInfo.Picture)
            {
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "Sell-to Customer No." = FIELD ("No.");
                //The property 'DataItemTableView' shouldn't have an empty value.
                //DataItemTableView = '';
                column(Priortize; Priortize)
                {
                }
                dataitem(SalesLine; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD ("Document Type"),
                                   "Document No." = FIELD ("No.");
                    DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.")
                                        WHERE ("Document Type" = CONST (Order));
                    column(PrintDate; CURRENTDATETIME)
                    {
                    }
                    column(ItemNo; SalesLine."No.")
                    {
                    }
                    column(CustomerNo; Customer."No.")
                    {
                    }
                    column(CustName; "Sales Header"."Sell-to Customer Name")
                    {
                    }
                    column(CustAddress; "Sales Header"."Sell-to Address")
                    {
                    }
                    column(CustAddress2; "Sales Header"."Sell-to Address 2")
                    {
                    }
                    column(CustCity; "Sales Header"."Sell-to City")
                    {
                    }
                    column(CustPostCode; "Sales Header"."Sell-to Post Code")
                    {
                    }
                    column(CustPhoneNo; Customer."Phone No.")
                    {
                    }
                    column(Description; SalesLine.Description)
                    {
                    }
                    column(PlannedDelDate; SalesLine."Planned Delivery Date")
                    {
                    }
                    column(DocumentNo; SalesLine."Document No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(SalesLine."Planned Delivery Date", PlannedDelDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    recPostCode.RESET;
                    recPostCode.SETRANGE(Code, "Sales Header"."Sell-to Post Code");
                    IF recPostCode.FINDFIRST THEN BEGIN
                        IF recPostCode."Prioritization INE" <> 0 THEN
                            Priortize := recPostCode."Prioritization INE"
                        ELSE
                            Priortize := 999999;
                    END ELSE
                        Priortize := 999999;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF BaseCalendar.GET(Customer."Base Calendar Code") THEN
                    BaseCalenderDesc := BaseCalendar.Name
                ELSE
                    BaseCalenderDesc := '';
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
                    field("Planned Delivery Date"; PlannedDelDate)
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            IF PlannedDelDate < TODAY THEN
                                ERROR('Planned Delivery date cannot be less than today');
                        end;
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

    trigger OnInitReport()
    begin
        IF PlannedDelDate = 0D THEN
            PlannedDelDate := WORKDATE;
    end;

    trigger OnPostReport()
    begin
    end;

    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        recPostCode: Record "Post Code";
        Priortize: Integer;
        CompInfo: Record "Company Information";
        BaseCalendar: Record "Base Calendar";
        BaseCalenderDesc: Text;
        PlannedDelDate: Date;

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

    procedure SetPlannedDate(p_Date: Date)
    begin

        PlannedDelDate := p_Date;
    end;
}

