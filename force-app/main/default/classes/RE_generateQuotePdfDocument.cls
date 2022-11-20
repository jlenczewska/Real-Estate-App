public with sharing class RE_generateQuotePdfDocument {
    public static final String TEAM_NAME = 'Real Estate King Team';

    @InvocableMethod
    public static void quoteCreate(List<Id> quoteIds) {
        List<Quote> quoteList = [SELECT ID, OpportunityId, ContactId, AccountId FROM Quote WHERE ID = :quoteIds];
        List<Contact> contactList = [SELECT ID, AccountId FROM Contact WHERE AccountId = :quoteList[0].AccountId];
        String contact;
        if (contactList != null) {
            contact = contactList[0].ID;
        } else {
            contact = UserInfo.getUserId();
        }
        createQuotePDF(quoteList[0].id, contactList[0].ID);
    }

    @future(callout=true)
    public static void createQuotePDF(Id quoteId, Id contactId) {
        Quote_email_Ids__c quoteIds = Quote_email_Ids__c.getInstance();
        String quoteUrl = '/quote/quoteTemplateDataViewer.apexp?';
        String quoteTemplateId = quoteIds.QuoteTemplateId__c;
        String quotePDFTemplateId = quoteIds.QuotePDFTemplateId__c;
        List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
        Quote newQuote = [SELECT ID FROM Quote WHERE ID = :quoteID];

        quoteUrl += 'id=' + quoteId;
        quoteUrl += '&headerHeight=197&footerHeight=10';
        quoteUrl += '&summlid=' + quotePDFTemplateId;

        PageReference pageRef = new PageReference(quoteUrl);

        Blob quoteBlob;

        if (Test.isRunningTest()) {
            quoteBlob = Blob.valueOf('Generate Pdf');
        } else {
            quoteBlob = pageRef.getContentAsPDF();
        }

        QuoteDocument quoteDoc = new QuoteDocument();
        quoteDoc.Document = quoteBlob;
        quoteDoc.QuoteId = quoteId;

        insert quoteDoc;
        sendEmail(newQuote.Id, quoteTemplateId, contactId, quoteDoc.QuoteId);
    }

    public static void sendEmail(Id quoteID, String emailTemplateID, Id contactID, Id quotedocID) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(contactID);
        message.setSenderDisplayName(TEAM_NAME);
        message.setReplyTo('no-reply@company.com');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        message.setTemplateID(emailTemplateID);
        message.setWhatId(quoteID);

        List<QuoteDocument> QDs = [SELECT Name, Document, ContentVersionDocumentId FROM QuoteDocument WHERE QuoteId = :quoteID];
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();

        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(QDs[QDs.size() - 1].Name);
        efa.setBody(QDs[QDs.size() - 1].Document);
        attachments.add(efa);

        message.setFileAttachments(attachments);

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}