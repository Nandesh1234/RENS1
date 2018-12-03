codeunit 50002 "Renseriet Automation Test INE"
{
    // version RENS1844.001

    // Test Cases
    // 1.  Test to Verify Job creation with No. Same as Customer No. from Customer Card
    // 2.  Select Customer & Create Service Item and Print Service Item label.
    // 3.  Registration for Carpet Items with Service Order Creation.
    // 4.  Registration for Furniture Items with Service Order Creation.
    // 5.  Pickup Order Screen to create Sales Order for Pick up time
    // 6.  Packing of Carpets by Scanning Service Item
    // 7.  Packing of Carpets if Service item doesnt exist
    // 8.  Screen to Show status of each Service Order
    // 9.  Check Registration Process with Non Service Item
    // 10. Check Registration Process where Customer No. is not defined on Service Item
    // 11. Check Registration Process with Default Size X & Size Y for Carpet Items
    // 12. Check Registration Process to allow modification of Quantity and Fixed Price on Screen after temp Service Line creation
    // 13. Check Custom fields flows on Service Line flows to Service Shipment Line on Posting


    Subtype = Test;

    trigger OnRun()
    begin
        // [FEATURE] [Service Mgt. Process Changes]
    end;

    var
        Assert: Codeunit Assert;
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibrarySales: Codeunit "Library - Sales";
        LibraryService: Codeunit "Library - Service";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryRandom: Codeunit "Library - Random";
        LibraryReportValidation: Codeunit "Library - Report Validation";
        isInitialized: Boolean;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckJobCreationOnCustomer()
    var
        Customer: Record "Customer";
        CustomerTestPage: TestPage "Customer Card";
        Job: Record "Job";
    begin
        // [SCENARIO] Test to Verify Job creation with No. Same as Customer No. from Customer Card

        // [GIVEN] Customer Record
        Initialize;
        LibrarySales.CreateCustomer(Customer);

        // [WHEN] Open Customer Card page and click on Create Job Action
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;

        // [THEN] Verify the Customer No. same as Job No.
        Job.GET(Customer."No.");
    end;

    [Test]
    [HandlerFunctions('ReportsRequestHandler')]
    procedure CheckServiceItemCreation()
    var
        PrintServiceItemLabelpage: TestPage "Print Service Item Label INE";
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
    begin
        // [SCENARIO] Test to Verify Service Item Creation

        // [GIVEN] Customer Record
        Initialize;
        LibrarySales.CreateCustomer(Customer);

        // [WHEN] Open Print Service Item Label Page and select Customer No. & No of labels, and click on Create Service Item Action
        PrintServiceItemLabelpage.OPENEDIT;
        PrintServiceItemLabelpage."Customer No.".SETVALUE(Customer."No.");
        PrintServiceItemLabelpage."No of Items".SETVALUE(1);
        PrintServiceItemLabelpage."Create Service Item".INVOKE;

        // [THEN] Verify Service Item Created for the Customer selected
        VerifyServiceItemCreation(Customer."No.");
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckRegistrationCarpetwithServiceOrder()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer card";
    begin
        // [SCENARIO] Test to check Order Registration process of carpet items with service order creation

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        CreateItemVariant(itemservice."No.", ItemNonInventory."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 1);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        //UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select service Item
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ServiceItem."No.");

        // [THEN] Verify Service Item variable value updated or not
        OrderRegistrationTestPage."Service Item".ASSERTEQUALS(ServiceItem."No.");
        OrderRegistrationTestPage."Customer No".ASSERTEQUALS(Customer."No.");

        // [WHEN] On Order Registration page and enter Item Service
        OrderRegistrationTestPage.Input.SETVALUE(ItemService."No.");

        // [THEN] Verify Item Service variable value updated or not
        OrderRegistrationTestPage."Item No. Service".ASSERTEQUALS(ItemService."No.");
        OrderRegistrationTestPage."Item Variant".AssertEquals(ItemService."No.");

        // [WHEN] On Order Registration page and enter Size X
        OrderRegistrationTestPage.Input.SETVALUE(decSizeX);

        // [THEN] Verify Size X variable value updated or not
        OrderRegistrationTestPage."Size X".ASSERTEQUALS(decSizeX);

        // [WHEN] On Order Registration page and enter Size Y
        OrderRegistrationTestPage.Input.SETVALUE(decSizeY);

        // [THEN] Verify Size Y variable value updated or not
        OrderRegistrationTestPage."Size Y".ASSERTEQUALS(decSizeY);

        // [WHEN] On Order Registration page and select Item No.
        OrderRegistrationTestPage.Input.SETVALUE(ItemNonInventory."No.");

        // [THEN] Verify Service Order created or not
        ServiceHeader.SETRANGE("Customer No.", Customer."No.");
        ServiceHeader.FINDFIRST;

        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.FINDFIRST;

        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceItemLine.FINDFIRST;
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckRegistrationFurniturewithServiceOrder()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer Card";
    begin
        // [SCENARIO] Test to check Registration process of furniture items with service order creation

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        CreateItemVariant(itemservice."No.", ItemNonInventory."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 2);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        //UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select service Item
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ServiceItem."No.");

        // [THEN] Verify Service Item variable value updated or not
        OrderRegistrationTestPage."Service Item".ASSERTEQUALS(ServiceItem."No.");
        OrderRegistrationTestPage."Customer No".ASSERTEQUALS(Customer."No.");

        // [WHEN] On Order Registration page and enter Item Service
        OrderRegistrationTestPage.Input.SETVALUE(ItemService."No.");

        // [THEN] Verify Item Service variable value updated or not
        OrderRegistrationTestPage."Item No. Service".ASSERTEQUALS(ItemService."No.");
        OrderRegistrationTestPage."Item Variant".AssertEquals(ItemService."No.");

        // [WHEN] On Order Registration page and enter Quantity
        OrderRegistrationTestPage.Input.SETVALUE(decQuantity);

        // [THEN] Verify Quantity variable value updated or not
        OrderRegistrationTestPage.Quantity.ASSERTEQUALS(decQuantity);

        // [WHEN] On Order Registration page and select Item No.
        OrderRegistrationTestPage.Input.SETVALUE(ItemNonInventory."No.");


        // [THEN] Verify Service Order created or not
        ServiceHeader.SETRANGE("Customer No.", Customer."No.");
        ServiceHeader.FINDFIRST;

        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.FINDFIRST;

        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceItemLine.FINDFIRST;
    end;

    [Test]
    procedure CheckPickupScreenwithSalesOrder()
    var
        Customer: Record "Customer";
        PickupTestPage: TestPage "Picking Screen INE";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record "Item";
    begin
        // [SCENARIO] Test to check Pickup Screen with sales order creation

        // [GIVEN] Customer No.
        Initialize;
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItem(Item);
        UpdateItemNoOnSalesReceivableSetup(Item."No.");

        // [WHEN] On Order Pickup page, select customer no.
        PickupTestPage.OPENEDIT;
        PickupTestPage."Customer No.".SETVALUE(Customer."No.");

        // [THEN] Verify Sales Order created or not
        SalesHeader.SETRANGE("Sell-to Customer No.", Customer."No.");
        SalesHeader.FINDFIRST;

        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.FINDFIRST;
    end;

    [Test]
    [HandlerFunctions('ReportsRequestHandler')]
    procedure CheckPackingofCarpetsServiceItem()
    var
        PackingScreenTestPage: TestPage "Packing Screen INE";
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
    begin
        // [SCENARIO] Test to check packing of carpets

        // [GIVEN] Service Item No.
        Initialize;
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        LibraryService.CreateServiceHeader(ServiceHeader, 1, Customer."No.");
        LibraryService.CreateServiceItemLine(ServiceItemLine, ServiceHeader, ServiceItem."No.");
        LibraryService.CreateServiceLine(ServiceLine, ServiceHeader, 1, ItemNonInventory."No.");

        // [WHEN] On Packing Screen page, Scan Service Item no.
        PackingScreenTestPage.OPENEDIT;
        PackingScreenTestPage."Scan Service Item Label".SETVALUE(ServiceItem."No.");

        // [THEN] Verify Service Order Status changed or not
        ServiceItem.GET(ServiceItem."No.");
        ServiceHeader.GET(ServiceHeader."Document Type"::Order, ServiceHeader."No.");
        Assert.IsTrue(ServiceItem."Service Item Status INE" = ServiceItem."Service Item Status INE"::Packed, 'Service Item status is not packed');
        Assert.IsTrue(ServiceHeader."Order Status INE" = ServiceHeader."Order Status INE"::Packed, 'Service Order status is not packed');
    end;

    [Test]
    procedure CheckPackingofCarpetsNonServiceItem()
    var
        PackingScreenTestPage: TestPage "Packing Screen INE";
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        ErrMsg: Label 'The Service Item does not exist. Identification fields and values: No.';
    begin
        // [SCENARIO] Test to check packing of carpets

        // [GIVEN] Service Item No.
        Initialize;

        // [WHEN] On Packing Screen page, Scan Service Item no.
        PackingScreenTestPage.OPENEDIT;
        ASSERTERROR PackingScreenTestPage."Scan Service Item Label".SETVALUE('A');

        // [THEN] Verify Error Message
        Assert.IsTrue(STRPOS(GETLASTERRORTEXT, ErrMsg) > 0, GETLASTERRORTEXT);
        CLEARLASTERROR;
    end;

    [Test]
    procedure CheckServiceOrderStatusonServiceOrder()
    var
        ServiceOrderListTestPage: TestPage "Service Orders";
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
    begin
        // [SCENARIO] Test to check service order status field on service order list page

        // [GIVEN] Service Orders
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        LibraryService.CreateServiceHeader(ServiceHeader, 1, Customer."No.");
        LibraryService.CreateServiceItemLine(ServiceItemLine, ServiceHeader, ServiceItem."No.");
        LibraryService.CreateServiceLine(ServiceLine, ServiceHeader, 1, ItemNonInventory."No.");

        // [WHEN] On Service Order List Page
        ServiceOrderListTestPage.OPENVIEW;
        ServiceOrderListTestPage.GOTOKEY(ServiceHeader."Document Type"::Order, ServiceHeader."No.");

        // [THEN] Verify Service Order Status changed or not
        ServiceOrderListTestPage."Order Status".ASSERTEQUALS(ServiceHeader."Order Status INE");
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckRegistrationCarpetwithNonServiceItem()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer card";
    begin
        // [SCENARIO] Test to check Order Registration process with Non Service Item

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 1);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select non service Item
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ItemNonInventory."No.");

        // [THEN] Verify the message on Screen
        OrderRegistrationTestPage.Message.ASSERTEQUALS('Service Item No found');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckRegistrationCarpetwithServiceItemCustomerSelection()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer card";
    begin
        // [SCENARIO] Test to check Order Registration process with Service Item non default customer

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 1);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        RemoveCustomerOnServiceItem(ServiceItem);
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select service Item & then customer No.
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ServiceItem."No.");
        OrderRegistrationTestPage.Input.SETVALUE(Customer."No.");

        // [THEN] Verify Service Item variable value updated or not
        OrderRegistrationTestPage."Customer No".ASSERTEQUALS(Customer."No.");
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckRegistrationCarpetwithDefaultSizevalues()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer card";
    begin
        // [SCENARIO] Test to check Order Registration process with Default Size X & Size Y values

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        CreateItemVariant(itemservice."No.", ItemNonInventory."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 1);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        UpdateSizeParameterOnServiceItem(ServiceItem, decSizeX, decSizeY);
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select non service Item
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ServiceItem."No.");



        // [THEN] Verify the message on Screen
        OrderRegistrationTestPage."Size X".ASSERTEQUALS(decSizeX);
    end;


    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckRegistrationCarpetwithQuantityUpdateonScreen()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer card";
    begin
        // [SCENARIO] Test to check Order Registration process of carpet items with quantity and fixed price update

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        CreateItemVariant(itemservice."No.", ItemNonInventory."No.");
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 1);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select all values one by one
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ServiceItem."No.");
        OrderRegistrationTestPage.Input.SETVALUE(decSizeX);
        OrderRegistrationTestPage.Input.SETVALUE(decSizeY);
        OrderRegistrationTestPage.Input.SETVALUE(ItemNonInventory."No.");


        ServiceHeader.Reset();
        ServiceHeader.SETRANGE("Customer No.", Customer."No.");
        ServiceHeader.FINDFIRST;


        OrderRegistrationTestPage.ServiceLines.Filter.SetFilter("Document No.", ServiceHeader."No.");
        OrderRegistrationTestPage.ServiceLines.GoToKey(1, ServiceHeader."No.", 10000);
        OrderRegistrationTestPage.ServiceLines.Quantity.SetValue(200);


        // [THEN] Verify variables value on Screen
        ServiceLine.Reset();
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange("No.", ItemNonInventory."No.");
        ServiceLine.FINDFIRST;

        ServiceLine.TestField(Quantity, 200);


    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure CheckRegistrationCarpetwithFixedPriceUpdateandCreateServiceOrder()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer card";
    begin
        // [SCENARIO] Test to check Order Registration process of carpet items with fixed price update and create service order

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        CreateItemVariant(itemservice."No.", ItemNonInventory."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 1);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select all values one by one
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ServiceItem."No.");
        OrderRegistrationTestPage.Input.SETVALUE(decSizeX);
        OrderRegistrationTestPage.Input.SETVALUE(decSizeY);
        OrderRegistrationTestPage.Input.SETVALUE(ItemNonInventory."No.");

        ServiceHeader.Reset();
        ServiceHeader.SETRANGE("Customer No.", Customer."No.");
        ServiceHeader.FINDFIRST;

        OrderRegistrationTestPage.ServiceLines.GoToKey(ServiceHeader."Document Type"::Order, ServiceHeader."No.", 10000);
        OrderRegistrationTestPage.ServiceLines."Fixed Price".SetValue(25);

        // [THEN] Verify Fixed Price value on Service Order
        ServiceLine.SETRANGE("Document Type", ServiceLine."Document Type"::Order);
        ServiceLine.SETRANGE("No.", ItemNonInventory."No.");
        ServiceLine.FINDFIRST;
        Assert.IsTrue(ServiceLine."Unit Price" = 25, 'Fixed Price doesnt match on service order');
    end;

    [Test]
    [HandlerFunctions('MessageHandler,ServiceLinePageHandler')]
    procedure CheckRegistrationCarpetwithPostingServiceOrderLines()
    var
        Customer: Record "Customer";
        ServiceItem: Record "Service Item";
        ItemService: Record "Item";
        ItemNonInventory: Record "Item";
        OrderRegistrationTestPage: TestPage "Registration Screen INE";
        decQuantity: Decimal;
        decSizeX: Decimal;
        decSizeY: Decimal;
        ItemCategory: Record "Item Category";
        TempServiceLine: Record "Temp Service Line INE";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        ServiceItemLine: Record "Service Item Line";
        CustomerTestPage: TestPage "Customer card";
        ServiceLineTestPage: TestPage "Service Lines";
        ServiceOrderTestPage: TestPage "Service Order";
        ServiceShipmentLine: Record "Service Shipment Line";
    begin
        // [SCENARIO] Test to check Order Registration process of carpet items with create and posting service order

        // [GIVEN] Various masters required for Order Registration
        Initialize;
        decQuantity := LibraryRandom.RandDec(100, 2);
        decSizeX := LibraryRandom.RandDec(100, 2);
        decSizeY := LibraryRandom.RandDec(100, 2);
        LibrarySales.CreateCustomer(Customer);
        LibraryInventory.CreateItemCategory(ItemCategory);
        LibraryInventory.CreateItem(ItemService);
        LibraryInventory.CreateItem(ItemNonInventory);
        LibraryService.CreateServiceItem(ServiceItem, Customer."No.");
        CreateItemVariant(ItemService."No.", ItemNonInventory."No.");
        UpdateCategoryTypeOnCategoryMaster(ItemCategory, 1);
        UpdateItemTypeandCategoryonItemMaster(ItemService, ItemNonInventory, ItemCategory);
        UpdateItemOnServiceItem(ServiceItem, ItemService."No.");
        CustomerTestPage.OPENEDIT;
        CustomerTestPage.GOTOKEY(Customer."No.");
        CustomerTestPage."Create Job".INVOKE;


        // [WHEN] Open Order Registration page and select all values one by one
        OrderRegistrationTestPage.OPENEDIT;
        OrderRegistrationTestPage.Input.SETVALUE(ServiceItem."No.");
        OrderRegistrationTestPage.Input.SETVALUE(decSizeX);
        OrderRegistrationTestPage.Input.SETVALUE(decSizeY);
        OrderRegistrationTestPage.Input.SETVALUE(ItemNonInventory."No.");

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceLine."Document Type"::Order);
        ServiceLine.SETRANGE("No.", ItemNonInventory."No.");
        ServiceLine.FINDFIRST;

        ServiceOrderTestPage.OPENEDIT;
        ServiceOrderTestPage.GOTOKEY(ServiceLine."Document Type"::Order, ServiceLine."Document No.");
        ServiceOrderTestPage.ServItemLines."Service Lines".INVOKE;

        // [THEN] Verify Fixed Price value on Service Order
        ServiceShipmentLine.RESET;
        ServiceShipmentLine.SETRANGE("Order No.", ServiceLine."Document No.");
        ServiceShipmentLine.SETRANGE("No.", ServiceLine."No.");
        ServiceShipmentLine.FINDFIRST;

        ServiceShipmentLine.TESTFIELD("Size X INE", decSizeX);
        ServiceShipmentLine.TESTFIELD("Size Y INE", decSizeY);
    end;

    procedure UpdateItemTypeandCategoryonItemMaster(var ItemService: Record "Item"; var ItemNonInventory: Record "Item"; var ItemCategory: Record "Item Category")
    begin
        ItemService.Type := ItemService.Type::Service;
        ItemService."Item Category Code" := ItemCategory.Code;
        ItemService.MODIFY;

        ItemNonInventory.Type := ItemNonInventory.Type::"Non-Inventory";
        ItemNonInventory."Item Category Code" := ItemCategory.Code;
        ItemNonInventory.MODIFY;
    end;

    procedure UpdateItemOnServiceItem(var ServiceItem: Record "Service Item"; ItemNo: Code[20])
    begin
        ServiceItem."Item No." := ItemNo;
        ServiceItem.MODIFY;
    end;

    procedure RemoveCustomerOnServiceItem(var ServiceItem: Record "Service Item")
    begin
        ServiceItem."Customer No." := '';
        ServiceItem.MODIFY;
    end;

    procedure UpdateCategoryTypeOnCategoryMaster(var ItemCategory: Record "Item Category"; CategoryType: Option)
    begin

        ItemCategory."Category Type INE" := CategoryType;
        ItemCategory.MODIFY;
    end;

    procedure UpdateItemNoOnSalesReceivableSetup(ItemNo: Code[20])
    var
        SRSetup: Record "Sales & Receivables Setup";
    begin
        SRSetup.GET;
        SRSetup."Item No. for Truck Route INE" := ItemNo;
        SRSetup.MODIFY;
    end;

    procedure CreateItemVariant(ItemNoService: code[20]; ItemNoNonInv: code[20])
    var
        ItemVariant: record "Item Variant";
    begin

        ItemVariant.INIT;
        ItemVariant.VALIDATE("Item No.", ItemNoNonInv);
        ItemVariant.VALIDATE(Code, ItemNoService);
        ItemVariant.VALIDATE(Description, ItemVariant.Code);
        ItemVariant.INSERT(TRUE);
    end;

    procedure UpdateSizeParameterOnServiceItem(var ServiceItem: Record "Service Item"; decSizeX: Decimal; decSizeY: Decimal)
    begin
        ServiceItem."Size X INE" := decSizeX;
        ServiceItem."Size Y INE" := decSizeY;
        ServiceItem.MODIFY;
    end;

    procedure VerifyServiceItemCreation(CustomerNo: Code[20])
    var
        ServiceItem: Record "Service Item";
        Item: Record "Item";
    begin
        ServiceItem.SETRANGE("Customer No.", CustomerNo);
        ServiceItem.FINDFIRST;
    end;

    local procedure Initialize()
    begin
        // Lazy Setup.
        LibraryVariableStorage.Clear;

        IF isInitialized THEN
            EXIT;

        isInitialized := TRUE;
        COMMIT;
    end;

    [MessageHandler]
    procedure MessageHandler(Message: Text[1024])
    begin
    end;

    [RequestPageHandler]
    procedure ReportsRequestHandler(var PrintServiceItemLabel: TestRequestPage "Service Item Label")
    begin
        // Report Request Page
        PrintServiceItemLabel.Cancel.Invoke();

    end;



    [ModalPageHandler]
    procedure ServiceLinePageHandler(var ServiceLinePage: TestPage "Service Lines")
    begin
        // Page Handler
        ServiceLinePage.Post.INVOKE;
    end;
}

