codeunit 50000 "Renseriet Functions INE"
{
    // version RENS1844.001


    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Page, 21, 'OnAfterActionEvent', 'Create Job', false, false)]
    procedure OnCustomerActionCreateJob(var Rec: Record Customer)
    var
        Job: Record "Job";
        JobTask: Record "Job Task";
    begin

        IF NOT Job.GET(Rec."No.") THEN BEGIN
            Job.INIT;
            Job.VALIDATE("No.", Rec."No.");
            Job.INSERT(TRUE);
            Job.VALIDATE("Bill-to Customer No.", Rec."No.");
            Job.MODIFY(TRUE);

            JobTask.INIT;
            JobTask.VALIDATE("Job No.", Job."No.");
            JobTask.VALIDATE("Job Task No.", Rec."No." + 'JT001');
            JobTask.INSERT(TRUE);
            JobTask.VALIDATE("Job Task Type", JobTask."Job Task Type"::Posting);
            JobTask.MODIFY(TRUE);

            MESSAGE('Job Created');
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5981, 'OnBeforeConfirmServPost', '', false, false)]
    procedure OnBeforePostServiceOrder(var ServiceHeader: Record "Service Header"; var HideDialog: Boolean; var Ship: Boolean; var Consume: Boolean; var Invoice: Boolean; var IsHandled: Boolean)
    begin
        HideDialog := TRUE;
        Ship := TRUE;
        Consume := TRUE;
    end;

    [EventSubscriber(ObjectType::Page, 50001, 'OnBeforeValidateEvent', 'Quantity', False, False)]
    local procedure OnBeforeValidateQuantityRegistrationServiceLine(VAR Rec: Record "Service Line"; VAR xRec: Record "Service Line")
    begin
        rec.Validate("Qty. to Consume", 0);
    end;

    procedure SendEmail()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Text50000: Label 'SMTP Setup doesnt exist';
        CompInfo: Record "Company Information";
        SRSetup: Record "Sales & Receivables Setup";
        RepTruckRoute: Report "Truck Route";
        Text50001: Label 'Please find attached truck route report for any route due.';
        XMLParameter: Text;
        DataOutStream: OutStream;
        DataInstream: InStream;
        TempServiceItem: Record "Service Item" temporary;
    begin

        IF NOT SMTPMailSetup.GET THEN BEGIN
            ERROR(Text50000);
        END;

        SMTPMailSetup.GET;
        CompInfo.GET;
        SRSetup.GET;

        CLEAR(SMTPMail);

        RepTruckRoute.SetPlannedDate(TODAY + 1);

        TempServiceItem."Email Data INE".CreateOutStream(DataOutStream, TextEncoding::UTF8);
        TempServiceItem."Email Data INE".CreateInStream(DataInstream, TextEncoding::UTF8);

        RepTruckRoute.SaveAs(XMLParameter, ReportFormat::Pdf, DataOutStream);

        SMTPMail.CreateMessage(COMPANYNAME, SMTPMailSetup."User ID", SRSetup."To EmailID Truck Notification INE", 'Alert : Truck is due', '', TRUE);

        SMTPMail.AppendBody('Hello,');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(Text50001);
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('Thanks.');

        SMTPMail.AddAttachmentStream(DataInstream, 'Truck Route' + '.pdf');
        SMTPMail.Send;

    end;
}

