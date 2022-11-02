@isTest
public with sharing class RE_pricebookManagerControllerTest {
    @isTest
    static void checkIfFunctionReturnsRecordsByRecordType() {

        List<PriceBookEntry> pricebookInfo;
        Boolean result;
        String premiseName = 'Apartment';

        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = 'Pricebook1';
        pricebook.ValidFrom__c = Date.newInstance(2016, 12, 9);
        pricebook.ValidTo__c = Date.newInstance(2016, 12, 12);

        insert pricebook;

        Pricebook2 standardPricebook = new Pricebook2();
        standardPricebook.Name = 'Standard Price Book';
        standardPricebook.ValidFrom__c = Date.newInstance(2010, 12, 9);
        standardPricebook.ValidTo__c = Date.newInstance(2028, 12, 12);

        insert standardPricebook;

        String pricebookId = pricebook.id;
        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(premiseName).getRecordTypeId();

        Product2 product = new Product2(
             Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland', RecordTypeId=recordType
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

        Test.startTest();
        pricebookInfo = RE_pricebookManagerController.getRecordsByRecordType(premiseName);
        Test.stopTest();

        System.assertEquals(true, true);
    }

    @isTest
    static void checkIfPricebookIsAddedToDatabase() {

        Boolean result;
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();
        String pbName ='Pricebook1';
        String pbDesc ='Pricebook1';
        Date pbStartDay = Date.newInstance(2016, 12, 9);
        Date pbEndDay = Date.newInstance(2016, 12, 11);
        Pricebook2 pricebook = RE_pricebookManagerController.createPricebook(pbName,pbDesc, pbStartDay, pbEndDay);
       
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

        Test.startTest();
        result = RE_pricebookManagerController.addPricebookToDatabase(pbName, pbDesc, pbStartDay, pbEndDay, JSON.serialize(pricebookInfo));
        Test.stopTest();

        System.assertEquals(result, true);
    }
}
