public class generateQuotePdfDocument {

  @InvocableMethod
  public static void QuoteCreate(List < Id > quoteIds) {

      List < Quote > quoteList = [SELECT ID, OpportunityId, ContactId FROM Quote WHERE ID =: quoteIds];
      CreateQuotePDF(quoteList[0].id, quoteList[0].ContactId);
  }

  @future(callout = true)
  public static void CreateQuotePDF(Id quoteId, Id contactId) {

      String quoteUrl = '/quote/quoteTemplateDataViewer.apexp?';
      String quoteTemplateId = Label.QuoteTemplateId;
      String QuotePDFTemplateId = Label.QuotePDFTemplateId;
      List < QuoteDocument > lstQuoteDoc = new List < QuoteDocument > ();
      Quote newQuote = [SELECT ID FROM Quote WHERE ID =: quoteID];

      quoteUrl += 'id=' + quoteId;
      quoteUrl += '&headerHeight=197&footerHeight=10';
      quoteUrl += '&summlid=' + QuotePDFTemplateId;

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
      SendEmail(newQuote.Id, quoteTemplateId, contactId, quoteDoc.QuoteId);
  }

  public static void SendEmail(Id quoteID, String emailTemplateID, Id contactID, Id quotedocID) {

      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
      //   message.setTargetObjectId(contactID);
      message.setTargetObjectId(UserInfo.getUserId());
      message.setSenderDisplayName('Company Support');
      message.setReplyTo('no-reply@company.com');
      message.setUseSignature(false);
      message.setBccSender(false);
      message.setSaveAsActivity(false);
      message.setTemplateID(emailTemplateID);
      message.setWhatId(quoteID);

      List < QuoteDocument > QDs = [SELECT Name, Document, ContentVersionDocumentId FROM QuoteDocument WHERE QuoteId =: quoteID];
      List < Messaging.EmailFileAttachment > attachments = new List < Messaging.EmailFileAttachment > ();

      Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
      efa.setFileName(QDs[QDs.size() - 1].Name);
      efa.setBody(QDs[QDs.size() - 1].Document);
      attachments.add(efa);

      message.setFileAttachments(attachments);

      Messaging.SingleEmailMessage[] messages = new List < Messaging.SingleEmailMessage > {
          message
      };
      Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
  }
}