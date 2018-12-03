page 50013 "Item FactBox Pg. INE"
{
    // version TPO18.10.01
    // TPO18.10.01 - New factbox form created for the Transfers Shipments Per Order functionality

    Caption = 'Items';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Item variant";


    layout
    {
        area(content)
        {
            repeater(Control37010107)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Type of service';
                }


            }
        }
    }

    actions
    {
    }

}

