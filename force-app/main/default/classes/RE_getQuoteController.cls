public without sharing class RE_getQuoteController {
    public static final String OPPORTUNITY_STAGE = 'Prospecting';
    public static final String RECORD_TYPE_B2C = 'B2C';
    public static final String TEAM_NAME = 'Real Estate King Team';
    public static final String ORG_DEFAULT_ADDRESS = 'julia.lenczewska@britenet.com.pl';
    public static final String QUOTE_NAME_PREFIX = 'Quote-';
    public static final String EMAIL_TEMPLATE_NAME = 'RE_Send Email Quote';

    @AuraEnabled
    public static void createQuote(String recordId) {
        Decimal price;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(RECORD_TYPE_B2C).getRecordTypeId();
        User currUser = [SELECT firstname, lastname, id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Account account = [SELECT Id, firstname, lastname FROM Account WHERE PersonContactId = :currUser.ContactId LIMIT 1];
        List<Id> quoteListIds = new List<Id>();

        try {
            if (shouldCreateNewOpportunity(recordId, account)) {
                Opportunity newOpp = new Opportunity(
                    Name = account.firstname + ' ' + account.lastname,
                    AccountId = account.id,
                    StageName = OPPORTUNITY_STAGE,
                    CloseDate = Date.today() + 30,
                    RecordTypeId = oppRecordTypeId
                );
                insert newOpp;

                newOpp.OwnerId = [SELECT Agent__c, Id FROM Product2 WHERE Id = :recordId LIMIT 1].Agent__c;
                update newOpp;
                price = getProductPrice(recordId);
                List<PricebookEntry> pbEntry = [
                    SELECT Product2ID, Pricebook2ID, UnitPrice, Id
                    FROM PricebookEntry
                    WHERE Product2ID = :recordId AND UnitPrice = :price
                ];
                OpportunityLineItem oppLI = new OpportunityLineItem(
                    OpportunityId = newOpp.Id,
                    Quantity = 1,
                    PricebookEntryId = pbEntry[0].id,
                    TotalPrice = pbEntry[0].UnitPrice
                );
                insert oppLI;
                Quote newQuote = new Quote(
                    Name = QUOTE_NAME_PREFIX + newOpp.name,
                    opportunityId = newOpp.id,
                    Pricebook2ID = pbEntry[0].Pricebook2ID,
                    OwnerId = newOpp.OwnerId
                );
                insert newQuote;
                quoteListIds.add(newQuote.id);
            } else {
                price = getProductPrice(recordId);
                List<Opportunity> existingOpp = [SELECT id FROM Opportunity WHERE AccountId = :account.id];
                Set<Id> existingOppIds = new Set<Id>();

                for (Opportunity opp : existingOpp) {
                    existingOppIds.add(opp.id);
                }
                Quote quotes = [SELECT id FROM Quote WHERE opportunityId = :existingOpp[0].id];
                List<Quote> quoteOfOpportunity = [SELECT Id, OpportunityId FROM Quote WHERE OpportunityId IN :existingOppIds];
                Set<Id> existingQuotesIds = new Set<Id>();

                for (Quote q : quoteOfOpportunity) {
                    existingQuotesIds.add(q.id);
                }

                List<QuoteLineItem> quoteList123 = [
                    SELECT Id, Product2Id, UnitPrice, QuoteId
                    FROM QuoteLineItem
                    WHERE UnitPrice = :price AND QuoteId IN :existingQuotesIds AND Product2Id = :recordId
                ];
                List<OpportunityLineItem> quoteList = [
                    SELECT Id, PricebookEntryId, Product2Id, UnitPrice, Name
                    FROM OpportunityLineItem
                    WHERE UnitPrice = :price AND OpportunityId IN :existingOppIds AND Product2Id = :recordId
                ];
                Quote quoteToEmail = [SELECT Id, OpportunityId FROM Quote WHERE Id = :quoteList123[0].QuoteId];
                quoteListIds.add(quoteToEmail.Id);
            }
            Send_Email_With_Quote__e newEvent = new Send_Email_With_Quote__e();
            newEvent.quoteId__c = quoteListIds[0];
            newEvent.UserId__c = currUser.id;

            Database.SaveResult sr = EventBus.publish(newEvent);
        } catch (Exception exc) {
            throw newMessageException(exc.getMessage());
        }
    }

    @future(callout=true)
    public static void createQuotePDF(Id quoteId, Id contactId) {
        String quoteUrl = Url.getSalesforceBaseUrl().toExternalForm() + '/quote/quoteTemplateDataViewer.apexp?';
        quoteUrl += 'id=' + quoteId;
        quoteUrl += '&headerHeight=197&footerHeight=10';
        quoteUrl += '&summlid=0EH7Q000006LgiX';

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
        sendEmail(quoteId, contactId);
    }

    public static void sendEmail(Id quoteID, Id contactID) {
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :ORG_DEFAULT_ADDRESS];
        EmailTemplate emailTemplate = [SELECT Id, name FROM EmailTemplate WHERE Name = :EMAIL_TEMPLATE_NAME LIMIT 1];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(contactID);
        message.setSaveAsActivity(false);
        message.setTemplateID(emailTemplate.Id);
        message.setWhatId(quoteID);
        message.setOrgWideEmailAddressId(owea.get(0).Id);

        QuoteDocument QD = [SELECT Name, Document, ContentVersionDocumentId FROM QuoteDocument WHERE QuoteId = :quoteID LIMIT 1];
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(QD.Name);
        attachment.setBody(QD.Document);
        attachments.add(attachment);
        message.setFileAttachments(attachments);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }

    private static Decimal getProductPrice(String recordId) {
        List<PricebookEntry> customPricebookEntry = new List<PricebookEntry>();
        List<PricebookEntry> standardPricebookEntry = new List<PricebookEntry>();
        Decimal price;

        List<pricebook2> standardPricebook = [SELECT Id FROM pricebook2 WHERE isactive = TRUE AND isStandard = TRUE];
        List<pricebook2> customPricebook = [SELECT Id FROM pricebook2 WHERE isactive = TRUE AND isStandard = FALSE];
        if (customPricebook.size() > 0) {
            customPricebookEntry = [
                SELECT Product2ID, Pricebook2ID, UnitPrice
                FROM PricebookEntry
                WHERE Product2ID = :recordId AND Pricebook2ID = :customPricebook[0].Id
            ];
        }
        standardPricebookEntry = [
            SELECT Product2ID, Pricebook2ID, UnitPrice
            FROM PricebookEntry
            WHERE Product2ID = :recordId AND Pricebook2ID = :standardPricebook[0].Id
        ];

        if (customPricebookEntry.size() > 0) {
            price = customPricebookEntry[0].UnitPrice;
        } else {
            price = standardPricebookEntry[0].UnitPrice;
        }
        return price;
    }

    private static Boolean shouldCreateNewOpportunity(Id recordId, Account account) {
        Set<Id> idsOfExistingOpportunities = new Set<Id>();
        List<Opportunity> existingOppForAccount = [SELECT Id, AccountId FROM Opportunity WHERE AccountId = :account.id];
        Decimal price = getProductPrice(recordId);

        for (Opportunity opp : existingOppForAccount) {
            idsOfExistingOpportunities.add(opp.Id);
        }
        List<OpportunityLineItem> existingOppLI = [
            SELECT Id, PricebookEntryId, Product2Id, UnitPrice, Name
            FROM OpportunityLineItem
            WHERE OpportunityId IN :idsOfExistingOpportunities
        ];
        Set<Id> idsOfExistingOpportunitiesLI = new Set<Id>();

        for (OpportunityLineItem opp : existingOppLI) {
            idsOfExistingOpportunitiesLI.add(opp.PricebookEntryId);
        }
        List<PricebookEntry> existingPBEntryForRecord = [
            SELECT Id, Pricebook2Id, UnitPrice, Product2Id
            FROM PricebookEntry
            WHERE UnitPrice = :price AND Product2Id = :recordId
        ];

        if (existingPBEntryForRecord.size() > 0) {
            List<OpportunityLineItem> existingOppLIList = [
                SELECT Id, PricebookEntryId, OpportunityId
                FROM OpportunityLineItem
                WHERE OpportunityId IN :idsOfExistingOpportunities AND PricebookEntryId = :existingPBEntryForRecord[0].id
            ];
            if (existingOppLIList.size() > 0) {
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }
}
