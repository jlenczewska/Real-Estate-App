@isTest 
public with sharing class QuoteTriggerTest {
   
    @isTest 
    static void TestInsertQuote() {
        
        List<Product2> products = Test.loadData(Product2.sObjectType, 'sample_Product2');
        Product2 product = (Product2)products[0];

        Id pricebookId = Test.getStandardPricebookId();

        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account acc = new Account(LastName='Schmoe',RecordTypeId = recordType.id);
        insert acc;

        Opportunity opp = new Opportunity(Name ='00New mAWS Deal',
        AccountID =acc.id,
        StageName = 'Customer Won',
        Amount = 3000,
        CloseDate = System.today());
        insert opp;

        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;

        OpportunityLineItem oppLineItem = new OpportunityLineItem(
            Product2Id = product.id,
            TotalPrice = 3000,
            PricebookEntryId = pbEntry.Id,
            OpportunityId = opp.Id,
            Quantity = 1
        );
        insert oppLineItem;
        
        Quote quote = new Quote(Name='Test Quote', OpportunityId = opp.Id);
        insert quote;
        List <QuoteLineItem> quoteLineItems = [SELECT id FROM QuoteLineItem];

        System.assertEquals(quoteLineItems.size(), 1);

    }
}
