page 50000 "Registration Screen INE"
{
    // version RENS1844.001

    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Registration Screen';
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group("General")
            {
                field(Input; Input)
                {
                    CaptionClass = '1,5,,' + InputCaption;
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    QuickEntry = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ParseInputLookup(Input, VariantExists, MiscItem);
                        CurrPage.UPDATE;
                    end;

                    trigger OnValidate()
                    begin
                        ParseInput(Input, VariantExists, MiscItem);
                        CurrPage.UPDATE;
                    end;
                }
                field(Message; ScreenMessage)
                {
                    Editable = false;
                    ApplicationArea = All;
                    QuickEntry = false;
                }
            }
            group(Related)
            {
                field("Service Item"; ServiceItemNo)
                {
                    Editable = false;
                    QuickEntry = false;
                    TableRelation = "Service Item";
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        Customer: Record "Customer";
                    begin
                    end;
                }
                field("Service Item Description"; ServiceItemDesc)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Customer No"; CustomerNo)
                {
                    Editable = false;
                    TableRelation = Customer;
                    ApplicationArea = All;
                }
                field("Customer Name"; CustomerName)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Size X"; SizeX)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Size Y"; SizeY)
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Item No. Service"; ItemNoService)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item No. Non. Inv."; ItemNo)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item Variant"; ItemVariant)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Job Code"; JobCode)
                {
                    TableRelation = Job;
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    trigger OnValidate()
                    var
                        JobTask: Record "Job Task";
                    begin
                        recServiceLine.Reset();
                        recServiceLine.SetRange(recServiceLine."Document Type", recServiceLine."Document Type"::Order);
                        recServiceLine.SetRange("Document No.", ServiceOrderNo);
                        //IF recServiceLine.GET(recServiceLine."Document Type"::Order, ServiceOrderNo, G_ServiceLineNo) THEN BEGIN
                        if recServiceLine.findset then repeat
                                                           jobtask.Reset();
                                                           jobtask.SetRange("Job No.", JobCode);
                                                           jobtask.FindFirst();
                                                           recServiceLine.VALIDATE("Job No.", JobCode);
                                                           recServiceLine.validate("Job Task No.", JobTask."Job Task No.");
                                                           recServiceLine.MODIFY(true);
                            until recServiceLine.next = 0;

                        CurrPage.ServiceLines.Page.Update();

                    end;
                }
                field(Circle; Circle)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Due Date"; DueDate)
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        recServiceLine.Reset();
                        recServiceLine.SetRange(recServiceLine."Document Type", recServiceLine."Document Type"::Order);
                        recServiceLine.SetRange("Document No.", ServiceOrderNo);
                        //IF recServiceLine.GET(recServiceLine."Document Type"::Order, ServiceOrderNo, G_ServiceLineNo) THEN BEGIN
                        if recServiceLine.findset then repeat

                                                           recServiceLine.VALIDATE("Qty. to Consume", Quantity);
                                                           recServiceLine.VALIDATE(Quantity, Quantity);
                                                           recServiceLine.MODIFY(true);
                            until recServiceLine.next = 0;

                        CurrPage.ServiceLines.Page.Update();
                        //Quantity := 0;
                    end;
                }
                field("Fixed Price"; FixedPrice)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        recServiceLine.Reset();
                        recServiceLine.SetRange(recServiceLine."Document Type", recServiceLine."Document Type"::Order);
                        recServiceLine.SetRange("Document No.", ServiceOrderNo);
                        //IF recServiceLine.GET(recServiceLine."Document Type"::Order, ServiceOrderNo, G_ServiceLineNo) THEN BEGIN
                        if recServiceLine.findset then repeat

                                                           recServiceLine.VALIDATE("Unit Price", FixedPrice);
                                                           recServiceLine.Validate("Fixed Price INE", FixedPrice);
                                                           recServiceLine.MODIFY(true);
                            until recServiceLine.next = 0;

                        CurrPage.ServiceLines.Page.Update();
                        //FixedPrice := 0;
                    end;
                }
                field(Memo; Memo)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                    QuickEntry = false;
                    trigger OnValidate()
                    var
                        recServiceItem: Record "Service Item";
                    begin
                        IF recServiceItem.GET(G_ServiceItem) THEN BEGIN
                            recServiceItem.VALIDATE("Memo INE", Memo);
                            recServiceItem.MODIFY(true);
                        END;
                        CurrPage.ServiceLines.Page.Update();
                    end;
                }
            }
            part(ServiceLines; 50001)
            {
                ApplicationArea = All;
                Editable = true;

            }
        }
        area(factboxes)
        {
            part(Control37010106; "Item FactBox Pg. INE")
            {
                SubPageLink = "Code" = FIELD ("No.");
                ApplicationArea = All;
                Caption = 'Type of Service';
            }

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

            group(Functions)
            {
                action("Done")
                {
                    Caption = 'Done';
                    Promoted = true;
                    ApplicationArea = All;
                    trigger OnAction();
                    begin
                        ResetALL();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        SetInputCaption(InputCaption, 'Service Item No.');
        SetScreenMessage(ScreenMessage, '');
        CurrPage.ServiceLines.PAGE.FilterData('', 0);
        CurrPage.UPDATE;
        rec.Reset();
        rec.SetRange("No.", '');

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

    end;

    var
        ServiceItemNo: Code[20];
        CustomerNo: Code[20];
        SizeX: Decimal;
        SizeY: Decimal;
        FixedPrice: Decimal;
        JobCode: Code[20];
        Quantity: Decimal;
        Circle: Boolean;
        ItemNo: Code[20];
        ItemVariant: Code[10];
        Input: Text;
        InputCaption: Text;
        ScreenMessage: Text;
        VariantExists: Boolean;
        DueDate: Date;
        MiscItem: Boolean;
        ItemNoService: Code[20];
        Memo: Text[100];
        ServiceItemDesc: Text;
        CustomerName: Text;
        ServiceOrderNo: Code[20];
        G_ServiceLineNo: Integer;
        recServiceLine: Record "Service Line";
        recServiceHeader: Record "Service Header";

        G_ServiceItem: Code[20];

    procedure SetInputCaption(var InputCaption: Text; Value: Text)
    begin
        InputCaption := Value;
    end;

    procedure SetScreenMessage(var ScreenMessage: Text; Value: Text)
    begin
        ScreenMessage := Value;
    end;

    local procedure ResetALL()
    begin
        ServiceItemNo := '';
        SizeX := 0;
        SizeY := 0;
        ItemNo := '';
        ItemVariant := '';
        Circle := FALSE;
        FixedPrice := 0;
        Quantity := 0;
        JobCode := '';
        CustomerNo := '';
        ItemNoService := '';
        Memo := '';
        ServiceItemDesc := '';
        CustomerName := '';
        MiscItem := false;
        SetInputCaption(InputCaption, 'Service Item No.');
        SetScreenMessage(ScreenMessage, '');
        rec.reset;
        rec.SetRange("No.", '');
        CurrPage.ServiceLines.PAGE.FilterData('', 0);
    end;

    local procedure ResetLine()
    begin
        ItemNo := '';
        //ItemVariant := '';
        //Circle := FALSE;
        //FixedPrice := 0;
        //Quantity := 0;
        //SizeX := 0;
        //SizeY := 0;
        SetInputCaption(InputCaption, 'Item No. Non Inv.');
        //SetScreenMessage(ScreenMessage, '');

    end;

    local procedure InsertTempServiceItemLine()
    var
        TempServiceLine: Record "Temp Service Line INE";
        EntryNo: Integer;
    begin
        TempServiceLine.RESET;
        IF TempServiceLine.FINDLAST THEN
            EntryNo := TempServiceLine."Entry No.";


        TempServiceLine.INIT;
        TempServiceLine."Entry No." := EntryNo + 1;
        TempServiceLine.VALIDATE("Item No.", ItemNo);
        TempServiceLine.VALIDATE("Item Variant", ItemVariant);
        TempServiceLine.VALIDATE("Service Item No.", ServiceItemNo);
        TempServiceLine.VALIDATE("Item No. Service", ItemNoService);
        if Not MiscItem then begin
            IF Circle THEN
                TempServiceLine.VALIDATE(Quantity, 3.14 * (SizeX / 2) * (SizeX / 2))
            ELSE
                TempServiceLine.VALIDATE(Quantity, SizeX * SizeY);
        end else
            TempServiceLine.VALIDATE(Quantity, Quantity);

        TempServiceLine.Circle := Circle;
        TempServiceLine."Size X" := SizeX;
        TempServiceLine."Size Y" := SizeY;
        TempServiceLine."Job Code" := JobCode;
        TempServiceLine."Assigned User ID" := USERID;
        TempServiceLine."Customer No." := CustomerNo;
        TempServiceLine."Fixed Price" := FixedPrice;
        TempServiceLine."Due Date" := DueDate;
        TempServiceLine.Memo := Memo;
        TempServiceLine.INSERT(TRUE);
    end;

    local procedure DeleteTempServiceLine()
    var
        TempServiceLine: Record "Temp Service Line INE";
    begin
        TempServiceLine.RESET;
        TempServiceLine.SETRANGE("Assigned User ID", USERID);
        IF TempServiceLine.FINDSET THEN
            TempServiceLine.DELETEALL;
    end;

    local procedure ParseInput(var Input: Text; var VariantExists: Boolean; var MiscItem: Boolean)
    var
        recItem: Record "Item";
        Customer: Record "Customer";
        InputDecimal: Decimal;
        recItem1: Record "Item";
        recItemVariant: Record "Item Variant";
        recServiceItem: Record "Service Item";
        recCategory: Record "Item Category";
    begin
        IF Input = '' THEN
            EXIT;

        if UPPERCASE(Input) = 'DONE' then begin
            ResetALL();
            Input := '';
            exit;
        end;

        IF ServiceItemNo = '' THEN BEGIN
            CurrPage.ServiceLines.PAGE.FilterData('', 0);
            CurrPage.UPDATE;
            ServiceOrderNo := '';
            G_ServiceLineNo := 0;
            G_ServiceItem := '';
            JobCode := '';
            Memo := '';
            Quantity := 0;
            FixedPrice := 0;

            recServiceItem.RESET;
            recServiceItem.SETRANGE("No.", Input);
            IF recServiceItem.FINDFIRST THEN BEGIN
                ServiceItemNo := Input;
                ServiceItemDesc := recServiceItem.Description;
                if recItem.GET(recServiceItem."Item No.") then begin
                    ItemNoService := recServiceItem."Item No.";
                    ItemVariant := recServiceItem."Item No.";

                    rec.Reset();
                    rec.SetRange("No.", ItemNoService);
                    //rec.SetRange(Type, rec.type::"Non-Inventory");
                    /*
                    ItemNo := recServiceItem."Item No.";
                    

                    recItemVariant.RESET;
                    recItemVariant.SETRANGE("Item No.", ItemNo);
                    IF recItemVariant.FINDFIRST THEN BEGIN
                        VariantExists := TRUE;
                    END;
                    */

                end;




                Circle := recServiceItem."Circle INE";

                IF recCategory.GET(recItem."Item Category Code") THEN;

                IF recCategory."Category Type INE" = recCategory."Category Type INE"::Carpet THEN
                    MiscItem := FALSE
                ELSE
                    MiscItem := TRUE;

                CustomerNo := recServiceItem."Customer No.";
                IF Customer.GET(CustomerNo) THEN
                    CustomerName := Customer.Name;

                SizeX := recServiceItem."Size X INE";
                SizeY := recServiceItem."Size Y INE";

                IF CustomerNo = '' THEN
                    SetInputCaption(InputCaption, 'Customer No.')
                ELSE BEGIN
                    if ItemNoService = '' then
                        SetInputCaption(InputCaption, 'Item No. Service')
                    else begin
                        IF MiscItem THEN
                            SetInputCaption(InputCaption, 'Quantity')
                        ELSE BEGIN
                            IF SizeX = 0 THEN
                                SetInputCaption(InputCaption, 'Size X')
                            ELSE
                                IF SizeY = 0 THEN
                                    SetInputCaption(InputCaption, 'Size Y')
                                ELSE
                                    if ItemNo = '' then
                                        SetInputCaption(InputCaption, 'Item No. Non-Inv.')
                                    else
                                        SetInputCaption(InputCaption, 'Item Variant');
                        END;
                    end;
                END;

                SetScreenMessage(ScreenMessage, '');
            END ELSE
                SetScreenMessage(ScreenMessage, 'Service Item No found');
            Input := '';
            EXIT;
        END;


        IF (ServiceItemNo <> '') AND (CustomerNo = '') THEN BEGIN
            Customer.GET(Input);
            CustomerNo := Input;
            CustomerName := Customer.Name;
            if ItemNoService = '' then
                SetInputCaption(InputCaption, 'Item No. Service')
            else begin
                IF MiscItem THEN
                    SetInputCaption(InputCaption, 'Quantity')
                ELSE BEGIN
                    IF SizeX = 0 THEN
                        SetInputCaption(InputCaption, 'Size X')
                    ELSE
                        IF SizeY = 0 THEN
                            SetInputCaption(InputCaption, 'Size Y')
                        ELSE
                            if ItemNo = '' then
                                SetInputCaption(InputCaption, 'Item No. Non Inv.')
                            else
                                SetInputCaption(InputCaption, 'Item Variant');
                END;
            end;
            Input := '';
            EXIT;
        END;

        IF (ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoService = '') THEN BEGIN
            if recItem.GET(Input) then begin
                ItemNoService := Input;
                ItemVariant := recItem."No.";
                //ItemNo := Input;
                rec.reset;
                //rec.SetRange(Type, rec.Type::"Non-Inventory");
                rec.SetRange("No.", ItemNoService);
                /*
                recItemVariant.RESET;
                recItemVariant.SETRANGE("Item No.", ItemNo);
                IF recItemVariant.FINDFIRST THEN BEGIN
                    VariantExists := TRUE;
                END;
                */
                SetScreenMessage(ScreenMessage, '');
            end else begin
                SetScreenMessage(ScreenMessage, 'Item not found');
                exit;
            end;


            IF recCategory.GET(recItem."Item Category Code") THEN;

            IF recCategory."Category Type INE" = recCategory."Category Type INE"::Carpet THEN
                MiscItem := FALSE
            ELSE
                MiscItem := TRUE;

            IF MiscItem THEN
                SetInputCaption(InputCaption, 'Quantity')
            ELSE BEGIN
                IF SizeX = 0 THEN
                    SetInputCaption(InputCaption, 'Size X')
                ELSE
                    IF SizeY = 0 THEN
                        SetInputCaption(InputCaption, 'Size Y')
                    ELSE
                        if ItemNo = '' then
                            SetInputCaption(InputCaption, 'Item No. Non. Inv.')
                        else
                            SetInputCaption(InputCaption, 'Item Variant');
            END;
            Input := '';
            exit;

        end;

        IF NOT MiscItem THEN
            IF (ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoservice <> '') and (SizeX = 0) THEN BEGIN
                EVALUATE(InputDecimal, Input);
                IF InputDecimal = 0 THEN
                    EXIT;
                SizeX := InputDecimal;

                if sizey = 0 then
                    SetInputCaption(InputCaption, 'Size Y')
                else
                    if ItemNo = '' then
                        SetInputCaption(InputCaption, 'Item No. Non Inv.')
                    else
                        SetInputCaption(InputCaption, 'Item Variant');

                Input := '';
                InputDecimal := 0;
                EXIT;
            END;

        IF NOT MiscItem THEN
            IF (ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoservice <> '') AND (SizeX <> 0) AND (SizeY = 0) THEN BEGIN
                EVALUATE(InputDecimal, Input);
                IF InputDecimal = 0 THEN
                    EXIT;
                SizeY := InputDecimal;
                if ItemNo = '' then
                    SetInputCaption(InputCaption, 'Item No. Non Inv.')
                else
                    SetInputCaption(InputCaption, 'Item Variant');
                Input := '';
                InputDecimal := 0;
                EXIT;
            END;

        IF MiscItem THEN
            IF (ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoservice <> '') AND (Quantity = 0) THEN BEGIN
                EVALUATE(InputDecimal, Input);
                IF InputDecimal = 0 THEN
                    EXIT;
                Quantity := InputDecimal;
                if ItemNo = '' then
                    SetInputCaption(InputCaption, 'Item No. Non Inv.')
                else
                    SetInputCaption(InputCaption, 'Item Variant');
                Input := '';
                InputDecimal := 0;
                EXIT;
            END;

        IF ((ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoservice <> '') AND (SizeX <> 0) AND (SizeY <> 0) AND (ItemNo = '')) OR
           ((ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoservice <> '') AND (Quantity <> 0) AND (ItemNo = ''))
           THEN BEGIN
            //recItem.GET(Input);

            recItem1.GET(ItemNoService);

            recItem.RESET;
            recItem.SETRANGE("Item Category Code", recItem1."Item Category Code");
            recItem.SETRANGE("No.", Input);
            recItem.SETRANGE(Type, recItem.Type::"Non-Inventory");
            IF recItem.FINDFIRST THEN BEGIN
                recItemVariant.RESET;
                recItemVariant.SETRANGE("Item No.", Input);
                recItemVariant.SetRange(Code, ItemVariant);
                IF not recItemVariant.FINDFIRST THEN begin
                    SetScreenMessage(ScreenMessage, 'Item & Variant Combination does not exist');
                    exit;
                end;
                ItemNo := Input;
                /*ItemNoService := Input;
                Rec.Reset();
                rec.SetRange("No.", ItemNo);
                */
                SetScreenMessage(ScreenMessage, '');

            END ELSE begin
                SetScreenMessage(ScreenMessage, ' Item doesnt belong to same category of Service Item');
                exit;
            end;

            /*
            recItemVariant.RESET;
            recItemVariant.SETRANGE("Item No.", ItemNo);
            IF recItemVariant.FINDFIRST THEN begin
                VariantExists := true;
                SetInputCaption(InputCaption, 'Item Variant')
            end ELSE BEGIN
                AutoCreateServiceOrder;
                ResetALL();
            END;
            */


            if ItemVariant <> '' then begin
                AutoCreateServiceOrder;
                ResetLine();
            end else
                SetInputCaption(InputCaption, 'Item Variant');


            Input := '';
            EXIT;
        END;

        IF (ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNo <> '') AND VariantExists and (ItemVariant = '') THEN BEGIN

            recItemVariant.RESET;
            recItemVariant.SETRANGE("Item No.", ItemNo);
            recItemVariant.SETRANGE(Code, Input);
            IF recItemVariant.FINDFIRST THEN BEGIN
                ItemVariant := Input;
                AutoCreateServiceOrder;
                ResetLine();
            END;
            Input := '';
            EXIT;
        END;
    end;

    local procedure ParseInputLookup(var Input: Text; var VariantExists: Boolean; var MiscItem: Boolean)
    var
        recItem: Record "Item";
        Customer: Record "Customer";
        InputDecimal: Decimal;
        recItem1: Record "Item";
        recItemVariant: Record "Item Variant";
        recServiceItem: Record "Service Item";
        recCategory: Record "Item Category";
    begin

        IF ServiceItemNo = '' THEN BEGIN
            recServiceItem.RESET;
            IF PAGE.RUNMODAL(0, recServiceItem) = ACTION::LookupOK THEN BEGIN
                CurrPage.ServiceLines.PAGE.FilterData('', 0);
                CurrPage.UPDATE;
                ServiceOrderNo := '';
                G_ServiceLineNo := 0;
                G_ServiceItem := '';
                JobCode := '';
                Memo := '';
                Quantity := 0;
                FixedPrice := 0;

                ServiceItemNo := recServiceItem."No.";

                ServiceItemDesc := recServiceItem.Description;
                if recItem.GET(recServiceItem."Item No.") then begin
                    ItemNoService := recServiceItem."Item No.";
                    ItemVariant := recServiceItem."Item No.";
                    rec.Reset();
                    rec.SetRange("No.", ItemNoService);
                    /*
                    ItemNo := recServiceItem."Item No.";
                    Rec.Reset();
                    rec.SetRange("No.", ItemNoService);
                    recItemVariant.RESET;
                    recItemVariant.SETRANGE("Item No.", ItemNo);
                    IF recItemVariant.FINDFIRST THEN BEGIN
                        VariantExists := TRUE;
                    END;
                    */
                end;

                Circle := recServiceItem."Circle INE";

                IF recCategory.GET(recItem."Item Category Code") THEN;

                IF recCategory."Category Type INE" = recCategory."Category Type INE"::Carpet THEN
                    MiscItem := FALSE
                ELSE
                    MiscItem := TRUE;

                SizeX := recServiceItem."Size X INE";
                SizeY := recServiceItem."Size Y INE";

                CustomerNo := recServiceItem."Customer No.";
                IF Customer.GET(CustomerNo) THEN
                    CustomerName := Customer.Name;

                IF CustomerNo = '' THEN
                    SetInputCaption(InputCaption, 'Customer No.')
                ELSE BEGIN
                    if ItemNoService = '' then
                        SetInputCaption(InputCaption, 'Item No. Service')
                    else begin
                        IF MiscItem THEN
                            SetInputCaption(InputCaption, 'Quantity')
                        ELSE BEGIN
                            IF SizeX = 0 THEN
                                SetInputCaption(InputCaption, 'Size X')
                            ELSE
                                IF SizeY = 0 THEN
                                    SetInputCaption(InputCaption, 'Size Y')
                                ELSE
                                    if ItemNo = '' then
                                        SetInputCaption(InputCaption, 'Item No. Non. Inv.')
                                    else
                                        SetInputCaption(InputCaption, 'Item Variant');
                        END;
                    end;
                END;

                SetScreenMessage(ScreenMessage, '');
            END ELSE
                SetScreenMessage(ScreenMessage, 'Service Item No found');
            Input := '';
            EXIT;
        END;


        IF (ServiceItemNo <> '') AND (CustomerNo = '') THEN BEGIN
            IF PAGE.RUNMODAL(0, Customer) = ACTION::LookupOK THEN begin
                CustomerNo := Customer."No.";
                CustomerName := Customer.Name;
            End ELSE
                EXIT;

            if ItemNoService = '' then
                SetInputCaption(InputCaption, 'Item No. Service')
            else begin
                IF MiscItem THEN
                    SetInputCaption(InputCaption, 'Quantity')
                ELSE BEGIN
                    IF SizeX = 0 THEN
                        SetInputCaption(InputCaption, 'Size X')
                    ELSE
                        IF SizeY = 0 THEN
                            SetInputCaption(InputCaption, 'Size Y')
                        ELSE
                            if ItemNo = '' then
                                SetInputCaption(InputCaption, 'Item No. Non Inv.')
                            else
                                SetInputCaption(InputCaption, 'Item Variant');
                END;
            end;
            Input := '';
            EXIT;
        END;

        IF (ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoService = '') THEN BEGIN
            recItem.RESET;
            recItem.SetRange(Type, recitem.Type::"Non-Inventory");
            IF PAGE.RUNMODAL(0, recItem) = ACTION::LookupOK THEN BEGIN
                ItemNoService := recItem."No.";
                ItemVariant := recItem."No.";
                //ItemNo := recItem."No.";
                rec.reset;
                //rec.SetRange(Type, rec.Type::"Non-Inventory");
                rec.SetRange("No.", ItemNoService);
                /*
                recItemVariant.RESET;
                recItemVariant.SETRANGE("Item No.", ItemNo);
                IF recItemVariant.FINDFIRST THEN BEGIN
                    VariantExists := TRUE;
                END;
                */
                SetScreenMessage(ScreenMessage, '');
            end else begin
                SetScreenMessage(ScreenMessage, 'Item not found');
                exit;
            end;


            IF recCategory.GET(recItem."Item Category Code") THEN;

            IF recCategory."Category Type INE" = recCategory."Category Type INE"::Carpet THEN
                MiscItem := FALSE
            ELSE
                MiscItem := TRUE;

            IF MiscItem THEN
                SetInputCaption(InputCaption, 'Quantity')
            ELSE BEGIN
                IF SizeX = 0 THEN
                    SetInputCaption(InputCaption, 'Size X')
                ELSE
                    IF SizeY = 0 THEN
                        SetInputCaption(InputCaption, 'Size Y')
                    ELSE
                        if ItemNo = '' then
                            SetInputCaption(InputCaption, 'Item No. Non. Inv.')
                        else
                            SetInputCaption(InputCaption, 'Item Variant');
            END;
            Input := '';
            exit;
        end;


        IF ((ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoService <> '') and (SizeX <> 0) AND (SizeY <> 0) AND (ItemNo = '')) OR
          ((ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNoService <> '') AND (Quantity <> 0) AND (ItemNo = ''))
           THEN BEGIN

            recItem1.GET(ItemNoService);
            recItem.RESET;
            recItem.SETRANGE("Item Category Code", recItem1."Item Category Code");
            recItem.SETRANGE(Type, recItem.Type::"Non-Inventory");
            IF PAGE.RUNMODAL(0, recItem) = ACTION::LookupOK THEN BEGIN
                recItemVariant.RESET;
                recItemVariant.SETRANGE("Item No.", recitem."No.");
                recItemVariant.SetRange(Code, ItemVariant);
                IF not recItemVariant.FINDFIRST THEN begin
                    SetScreenMessage(ScreenMessage, 'Item & Variant Combination does not exist');
                    exit;
                end;


                ItemNo := recItem."No.";
                /*
                ItemNoService := recItem."No.";
                Rec.Reset();
                rec.SetRange("No.", ItemNo);
                */
            END ELSE BEGIN
                EXIT;
            END;
            /*
            recItemVariant.RESET;
            recItemVariant.SETRANGE("Item No.", ItemNo);
            IF recItemVariant.FINDFIRST THEN BEGIN
                SetInputCaption(InputCaption, 'Item Variant');
                VariantExists := TRUE;
            END ELSE BEGIN
                AutoCreateServiceOrder;
                ResetALL();
            END;
            */
            if ItemVariant <> '' then begin
                AutoCreateServiceOrder;
                ResetLine();
            end else
                SetInputCaption(InputCaption, 'Item Variant');

            Input := '';
            EXIT;
        END;

        IF ((ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNo <> '') AND (ItemVariant = '') and (VariantExists) and (Quantity <> 0) or
            (ServiceItemNo <> '') AND (CustomerNo <> '') AND (ItemNo <> '') AND (ItemVariant = '') and (VariantExists) and (SizeX <> 0) and (SizeY <> 0)) THEN BEGIN
            recItemVariant.RESET;
            recItemVariant.SETRANGE("Item No.", ItemNo);
            IF PAGE.RUNMODAL(0, recItemVariant) = ACTION::LookupOK THEN BEGIN
                ItemVariant := recItemVariant.Code;
            END ELSE
                EXIT;
            IF ItemVariant <> '' THEN BEGIN
                AutoCreateServiceOrder;
                ResetLine();
            END;
            Input := '';
            EXIT;
        END;
    end;

    local procedure CreateServiceOrder()
    var
        ServiceHeader: Record "Service Header";
        ServiceItemLine: Record "Service Item Line";
        ServiceLine: Record "Service Line";
        TempServiceLine: Record "Temp Service Line INE";
        PrevCustomerNo: Code[20];
        PrevServiceItemNo: Code[20];
        ServiceItemLineNo: Integer;
        ServicelineNo: Integer;
        ServiceItem: Record "Service Item";
        Item: Record "Item";
        JobTask: Record "Job Task";
    begin

        TempServiceLine.RESET;
        TempServiceLine.SETRANGE("Assigned User ID", USERID);
        IF NOT TempServiceLine.FINDFIRST THEN
            EXIT;

        TempServiceLine.RESET;
        TempServiceLine.SETCURRENTKEY("Customer No.");
        TempServiceLine.SETRANGE("Assigned User ID", USERID);
        IF TempServiceLine.FINDSET THEN REPEAT
                                            IF (PrevCustomerNo = '') OR (PrevCustomerNo <> TempServiceLine."Customer No.") THEN BEGIN

                                                TempServiceLine.TESTFIELD("Customer No.");
                                                ServiceItem.RESET;
                                                ServiceItem.SETRANGE("No.", TempServiceLine."Service Item No.");
                                                IF ServiceItem.FINDFIRST THEN BEGIN
                                                    IF ServiceItem."Customer No." <> TempServiceLine."Customer No." THEN BEGIN
                                                        ServiceItem."Customer No." := TempServiceLine."Customer No.";
                                                        ServiceItem.MODIFY;
                                                    END;
                                                    IF TempServiceLine."Due Date" <> 0D THEN BEGIN
                                                        ServiceItem."Due Date INE" := TempServiceLine."Due Date";
                                                        ServiceItem.MODIFY;
                                                    END;
                                                    ServiceItem."Memo INE" := TempServiceLine.Memo;
                                                    ServiceItem."Service Item Status INE" := ServiceItem."Service Item Status INE"::Registered;
                                                    ServiceItem.MODIFY;
                                                END;

                                                ServiceHeader.RESET;
                                                ServiceHeader.SETRANGE("Customer No.", TempServiceLine."Customer No.");
                                                ServiceHeader.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
                                                ServiceHeader.SETRANGE("Order Date", WORKDATE);
                                                IF NOT ServiceHeader.FINDFIRST THEN BEGIN
                                                    ServiceHeader.INIT;
                                                    ServiceHeader.VALIDATE("Document Type", ServiceHeader."Document Type"::Order);
                                                    ServiceHeader.INSERT(TRUE);
                                                    ServiceHeader.VALIDATE("Customer No.", TempServiceLine."Customer No.");
                                                    IF TempServiceLine."Due Date" <> 0D THEN
                                                        ServiceHeader.VALIDATE("Due Date", TempServiceLine."Due Date");
                                                    ServiceHeader."Order Status INE" := ServiceHeader."Order Status INE"::Registered;

                                                    ServiceHeader.VALIDATE("Your Reference", ServiceHeader."No.");
                                                    ServiceHeader.MODIFY(TRUE);
                                                END;
                                                ServiceItemLineNo := 0;
                                                ServicelineNo := 0;
                                            END;

                                            IF (PrevServiceItemNo = '') OR (PrevServiceItemNo <> TempServiceLine."Service Item No.") THEN BEGIN
                                                ServiceItemLine.RESET;
                                                ServiceItemLine.SETRANGE("Document Type", ServiceItemLine."Document Type"::Order);
                                                ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
                                                IF ServiceItemLine.FINDLAST THEN
                                                    ServiceItemLineNo := ServiceItemLine."Line No.";

                                                ServiceItemLine.RESET;
                                                ServiceItemLine.SETRANGE("Document Type", ServiceItemLine."Document Type"::Order);
                                                ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
                                                ServiceItemLine.SETRANGE("Item No.", TempServiceLine."Service Item No.");
                                                IF NOT ServiceItemLine.FINDFIRST THEN BEGIN
                                                    ServiceItemLine.INIT;
                                                    ServiceItemLine.VALIDATE("Document Type", ServiceItemLine."Document Type"::Order);
                                                    ServiceItemLine.VALIDATE("Document No.", ServiceHeader."No.");
                                                    ServiceItemLine.VALIDATE("Line No.", ServiceItemLineNo + 10000);
                                                    ServiceItemLine.INSERT(TRUE);
                                                    ServiceItemLine.VALIDATE("Service Item No.", TempServiceLine."Service Item No.");
                                                    ServiceItemLine.MODIFY(TRUE);
                                                END;
                                            END;

                                            ServiceLine.RESET;
                                            ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
                                            ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
                                            IF ServiceLine.FINDLAST THEN
                                                ServicelineNo := ServiceLine."Line No.";


                                            ServiceLine.INIT;
                                            ServiceLine.VALIDATE("Document Type", ServiceLine."Document Type"::Order);
                                            ServiceLine.VALIDATE("Document No.", ServiceHeader."No.");
                                            ServiceLine.VALIDATE("Service Item Line No.", ServiceItemLine."Line No.");
                                            ServiceLine.VALIDATE("Line No.", ServicelineNo + 10000);
                                            ServiceLine.VALIDATE(Type, ServiceLine.Type::Item);
                                            ServiceLine.VALIDATE("No.", TempServiceLine."Item No.");
                                            ServiceLine.VALIDATE("Variant Code", TempServiceLine."Item Variant");
                                            ServiceLine.VALIDATE(Quantity, TempServiceLine.Quantity);
                                            ServiceLine.VALIDATE("Qty. to Consume", TempServiceLine.Quantity);
                                            IF TempServiceLine."Fixed Price" <> 0 THEN
                                                ServiceLine.VALIDATE("Unit Price", TempServiceLine."Fixed Price");

                                            IF TempServiceLine."Job Code" <> '' THEN
                                                ServiceLine.VALIDATE("Job No.", TempServiceLine."Job Code")
                                            ELSE
                                                ServiceLine.VALIDATE("Job No.", TempServiceLine."Customer No.");

                                            JobTask.RESET;
                                            JobTask.SETRANGE("Job No.", ServiceLine."Job No.");
                                            IF JobTask.FINDFIRST THEN BEGIN
                                                ServiceLine.VALIDATE("Job Task No.", JobTask."Job Task No.");
                                                ServiceLine.VALIDATE("Job Line Type", ServiceLine."Job Line Type"::"Both Budget and Billable");
                                            END;

                                            ServiceLine.VALIDATE("Size X INE", TempServiceLine."Size X");
                                            ServiceLine.VALIDATE("Size Y INE", TempServiceLine."Size Y");
                                            ServiceLine.VALIDATE("Circle INE", TempServiceLine.Circle);
                                            ServiceLine.VALIDATE("Size category INE", ServiceItem."Size category INE");
                                            ServiceLine.VALIDATE("Fixed Price INE", TempServiceLine."Fixed Price");
                                            ServiceLine.INSERT(TRUE);

                                            ServicelineNo += 10000;

                                            PrevCustomerNo := TempServiceLine."Customer No.";
                                            PrevServiceItemNo := TempServiceLine."Service Item No.";
                                            Clear(ServiceHeader);
                                            Clear(ServiceItemLine);
                                            Clear(ServiceLine);

            UNTIL TempServiceLine.NEXT = 0;

        ResetALl;
        DeleteTempServiceLine;
        MESSAGE('Service Order Created');
    end;

    local procedure AutoCreateServiceOrder()
    var
        ServiceHeader: Record "Service Header";
        ServiceItemLine: Record "Service Item Line";
        ServiceLine: Record "Service Line";
        TempServiceLine: Record "Temp Service Line INE";
        PrevCustomerNo: Code[20];
        PrevServiceItemNo: Code[20];
        ServiceItemLineNo: Integer;
        ServicelineNo: Integer;
        ServiceItem: Record "Service Item";
        Item: Record "Item";
        JobTask: Record "Job Task";
    begin
        IF (ServiceItemNo = '') OR (CustomerNo = '') OR (ItemNo = '') THEN
            EXIT;

        ServiceItem.RESET;
        ServiceItem.SETRANGE("No.", ServiceItemNo);
        IF ServiceItem.FINDFIRST THEN BEGIN
            IF ServiceItem."Customer No." <> CustomerNo THEN BEGIN
                ServiceItem."Customer No." := CustomerNo;
                ServiceItem.MODIFY;
            END;
            IF DueDate <> 0D THEN BEGIN
                ServiceItem."Due Date INE" := DueDate;
                ServiceItem.MODIFY;
            END;
            ServiceItem."Memo INE" := Memo;
            ServiceItem."Service Item Status INE" := ServiceItem."Service Item Status INE"::Registered;
            ServiceItem."Item No." := ItemNoService;
            ServiceItem.MODIFY;
        END;

        ServiceHeader.RESET;
        ServiceHeader.SETRANGE("Customer No.", CustomerNo);
        ServiceHeader.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
        ServiceHeader.SETRANGE("Order Date", WORKDATE);
        IF NOT ServiceHeader.FINDFIRST THEN BEGIN
            ServiceHeader.INIT;
            ServiceHeader.VALIDATE("Document Type", ServiceHeader."Document Type"::Order);
            ServiceHeader.VALIDATE("Customer No.", CustomerNo);
            IF DueDate <> 0D THEN
                ServiceHeader.VALIDATE("Due Date", DueDate);
            ServiceHeader."Order Status INE" := ServiceHeader."Order Status INE"::Registered;
            ServiceHeader.INSERT(TRUE);
            ServiceHeader.VALIDATE("Your Reference", ServiceHeader."No.");
            ServiceHeader.MODIFY(TRUE);
        END;

        ServiceItemLineNo := 0;
        ServicelineNo := 0;

        ServiceItemLine.RESET;
        ServiceItemLine.SETRANGE("Document Type", ServiceItemLine."Document Type"::Order);
        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceItemLine.FINDLAST THEN
            ServiceItemLineNo := ServiceItemLine."Line No.";

        ServiceItemLine.RESET;
        ServiceItemLine.SETRANGE("Document Type", ServiceItemLine."Document Type"::Order);
        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceItemLine.SETRANGE("Service Item No.", ServiceItemNo);
        IF NOT ServiceItemLine.FINDFIRST THEN BEGIN
            ServiceItemLine.INIT;
            ServiceItemLine.VALIDATE("Document Type", ServiceItemLine."Document Type"::Order);
            ServiceItemLine.VALIDATE("Document No.", ServiceHeader."No.");
            ServiceItemLine.VALIDATE("Line No.", ServiceItemLineNo + 10000);
            ServiceItemLine.INSERT(TRUE);
            ServiceItemLine.VALIDATE("Service Item No.", ServiceItemNo);
            ServiceItemLine.MODIFY(TRUE);
        END;


        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
        ServiceLine.SetRange("Service Item No.", ServiceItemNo);
        ServiceLine.SetRange("No.", ItemNo);
        IF ServiceLine.FindFirst then begin
            SetScreenMessage(ScreenMessage, 'Type of service is already selected');
            ItemNo := '';
            exit;
        end;

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
        IF ServiceLine.FINDLAST THEN
            ServicelineNo := ServiceLine."Line No.";


        ServiceLine.INIT;
        ServiceLine.VALIDATE("Document Type", ServiceLine."Document Type"::Order);
        ServiceLine.VALIDATE("Document No.", ServiceHeader."No.");
        ServiceLine.VALIDATE("Service Item Line No.", ServiceItemLine."Line No.");
        ServiceLine.VALIDATE("Line No.", ServicelineNo + 10000);
        ServiceLine.VALIDATE(Type, ServiceLine.Type::Item);

        ServiceLine.VALIDATE("No.", ItemNo);
        IF ItemVariant <> '' THEN
            ServiceLine.VALIDATE("Variant Code", ItemVariant);

        if Not MiscItem then begin
            IF Circle THEN
                ServiceLine.VALIDATE(Quantity, 3.14 * (SizeX / 2) * (SizeX / 2))
            ELSE
                ServiceLine.VALIDATE(Quantity, SizeX * SizeY);
        end else
            ServiceLine.VALIDATE(Quantity, Quantity);

        ServiceLine.VALIDATE("Qty. to Consume", ServiceLine.Quantity);
        IF FixedPrice <> 0 THEN
            ServiceLine.VALIDATE("Unit Price", FixedPrice);

        IF JobCode <> '' THEN
            ServiceLine.VALIDATE("Job No.", JobCode)
        ELSE
            ServiceLine.VALIDATE("Job No.", CustomerNo);

        JobTask.RESET;
        JobTask.SETRANGE("Job No.", ServiceLine."Job No.");
        IF JobTask.FINDFIRST THEN BEGIN
            ServiceLine.VALIDATE("Job Task No.", JobTask."Job Task No.");
            ServiceLine.VALIDATE("Job Line Type", ServiceLine."Job Line Type"::"Both Budget and Billable");
        END;

        ServiceLine.VALIDATE("Size X INE", SizeX);
        ServiceLine.VALIDATE("Size Y INE", SizeY);
        ServiceLine.VALIDATE("Circle INE", Circle);
        ServiceLine.VALIDATE("Size category INE", ServiceItem."Size Category INE");
        ServiceLine.VALIDATE("Fixed Price INE", FixedPrice);
        ServiceLine.INSERT(TRUE);

        ServiceOrderNo := ServiceLine."Document No.";
        G_ServiceLineNo := ServiceLine."Line No.";
        G_ServiceItem := ServiceItemNo;

        if ItemVariant <> '' then
            ResetLine()
        else
            ResetALL();

        CurrPage.ServiceLines.PAGE.FilterData(ServiceOrderNo, G_ServiceLineNo);
        CurrPage.UPDATE;
    end;
}

