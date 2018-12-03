codeunit 50003 "Send Email INE"
{
    // version RENS1844.001

    trigger OnRun()
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

