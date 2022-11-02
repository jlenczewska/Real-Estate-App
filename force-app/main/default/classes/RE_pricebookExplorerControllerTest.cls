@isTest
public with sharing class RE_pricebookExplorerControllerTest {

    @isTest
    static void checkIfFunctionGetCorrectPricebooks() {
        List<Pricebook2> pricebooksList;
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = 'Pricebook1';
        pricebook.ValidFrom__c = Date.newInstance(2016, 12, 9);
        pricebook.ValidTo__c = Date.newInstance(2016, 12, 12);

        insert pricebook;

        String queryPhrase = 'Price';

        Test.startTest();
        pricebooksList = RE_pricebookExplorerController.getPricebooks(queryPhrase);
        Test.stopTest();

        System.assertEquals(pricebooksList.size(), 1);
    }

    @isTest
    static void checkIfFunctionReturnsCorrectRecord() {
        
        List<PriceBookEntry> pricebookInfo;
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = 'Pricebook1';
        pricebook.ValidFrom__c = Date.newInstance(2016, 12, 9);
        pricebook.ValidTo__c = Date.newInstance(2016, 12, 12);

        insert pricebook;

        Product2 product = new Product2(
             Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland'
        );

        insert product;

        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);

        PriceBookEntry pricebookEntry = new PriceBookEntry();
        pricebookEntry.Product2Id = product.id;
        pricebookEntry.PriceBook2Id = pricebook.id;
        pricebookEntry.IsActive=true;
        pricebookEntry.UnitPrice=100.0;
        pricebookEntry.UseStandardPrice=false;

        insert pricebookEntry;


        String pricebookId = pricebook.id;
        
        Test.startTest();
        pricebookInfo = RE_pricebookExplorerController.getPricebookInfo(pricebookId);
        Test.stopTest();

        System.assertEquals(pricebookInfo[0].PriceBook2Id, pricebookId);
    }

    @isTest
    static void checkIfFunctionUpdatesRecords() {
        
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();
        Boolean result;
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = 'Pricebook1';
        pricebook.ValidFrom__c = Date.newInstance(2016, 12, 9);
        pricebook.ValidTo__c = Date.newInstance(2016, 12, 12);

        insert pricebook;

        Product2 product = new Product2(
             Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland'
        );

        insert product;

        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);

        PriceBookEntry pricebookEntry = new PriceBookEntry();
        pricebookEntry.Product2Id = product.id;
        pricebookEntry.PriceBook2Id = pricebook.id;
        pricebookEntry.IsActive=true;
        pricebookEntry.UnitPrice=100.0;
        pricebookEntry.UseStandardPrice=false;

        insert pricebookEntry;

        pricebookInfo.add(pricebookEntry);

        String pricebookId = pricebook.id;
        
        Test.startTest();
        result = RE_pricebookExplorerController.updatePricebook(pricebookId, JSON.serialize(pricebookInfo));
        Test.stopTest();

        System.assertEquals(result, true);
    }

}
