@isTest
public with sharing class RE_pricebookExplorerControllerTest {

    public static final String SAMPLE_PRICEBOOK = 'sample_Pricebook2';
    public static final String SAMPLE_PRODUCT = 'sample_Product2';
    public static final String PREMISE_NAME = 'Apartment';

    @isTest
    static void shouldfUserEditPricebooks() {
      
        Boolean userShouldEditPricebooks = false;
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);

        System.runAs(u) {
            Test.startTest();
            userShouldEditPricebooks = RE_pricebookExplorerController.editShouldBeAvailable();
            Test.stopTest();
          }
         System.assertEquals(userShouldEditPricebooks, true);
    }

    @isTest
    static void shouldFunctionGetCorrectPricebooks() {
        List<Pricebook2> pricebooksList;
        
        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);

        Test.startTest();
        pricebooksList = RE_pricebookExplorerController.getPricebooks('Price');
        Test.stopTest();

        System.assertEquals(pricebooksList.size(), 1);
    }

    @isTest
    static void shouldFunctionGetCorrectEntries() {
        List<PriceBookEntry> pricebooksEntryList;
       
        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2)pricebooks[0];

        List<Product2> products = Test.loadData(Product2.sObjectType, SAMPLE_PRODUCT);
        Product2 product = (Product2)products[0];

        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);
        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=pricebook.id, UnitPrice=20000);

        Test.startTest();
        pricebooksEntryList = RE_pricebookExplorerController.getPricebookEntryInfo(pricebook.id);
        Test.stopTest();

        System.assertEquals(pricebooksEntryList.size(), 1);
    }

    @isTest
    static void checkIfFunctionReturnsCorrectRecord() {
        
        Pricebook2 pricebookInfo;
        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2)pricebooks[0];

        List<Product2> products = Test.loadData(Product2.sObjectType, SAMPLE_PRODUCT);
        Product2 product = (Product2)products[0];

        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);

        PriceBookEntry pricebookEntry = new PriceBookEntry();
        pricebookEntry.Product2Id = product.id;
        pricebookEntry.PriceBook2Id = pricebook.id;
        pricebookEntry.IsActive=true;
        pricebookEntry.UnitPrice=100.0;
        pricebookEntry.UseStandardPrice=false;

        insert pricebookEntry;
        
        Test.startTest();
        pricebookInfo = RE_pricebookExplorerController.getPricebookInfo(pricebook.id);
        Test.stopTest();

        System.assertEquals(pricebookInfo.Id, pricebook.id);
    }

    @isTest
    static void checkIfFunctionUpdatesRecords() {
        
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();
        Boolean result;

        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2)pricebooks[0];

        List<Product2> products = Test.loadData(Product2.sObjectType, SAMPLE_PRODUCT);
        Product2 product = (Product2)products[0];

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
        result = RE_pricebookExplorerController.updatePricebook(pricebook.id, JSON.serialize(pricebookInfo));
        Test.stopTest();

        System.assertEquals(result, true);
    }

    @isTest
    static void checkIfFunctionReturnsNotDisplayedRecords() {
        
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();
        List<Product2> pricebookExistingEntriesList = new List<Product2>();
        String result;

        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2)pricebooks[0];

        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        Product2 product1 = new Product2(
             Name='Premise1', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland', RecordTypeId=recordType, Area__c=300
        );
        insert product1;

        Product2 product2 = new Product2(
            Name='Premise2', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland', RecordTypeId=recordType, Area__c=300
        );
        insert product2;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true,
            ValidFrom__c = Date.newInstance(2010, 12, 9),
            ValidTo__c = Date.newInstance(2028, 12, 12)
        );
        
        update standardPricebook;

        insert new PriceBookEntry(Product2Id=product1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);
        PriceBookEntry pricebookEntry = new PriceBookEntry();
        pricebookEntry.Product2Id = product1.id;
        pricebookEntry.PriceBook2Id = pricebook.id;
        pricebookEntry.IsActive=true;
        pricebookEntry.UnitPrice=100.0;

        insert pricebookEntry;
        pricebookExistingEntriesList.add(product1);

        Test.startTest();
        result = RE_pricebookExplorerController.getMissingRecords(JSON.serialize(pricebookExistingEntriesList), pricebook.id);
        Test.stopTest();

        System.assertNotEquals(result, null);
    }

    @isTest
    static void checkIfFunctionAddNewRecordsToPricebook() {
        
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();
        List<Product2> pricebookExistingEntriesList = new List<Product2>();
        Boolean result;

        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2)pricebooks[0];

        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        Product2 product1 = new Product2(
             Name='Premise1', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland', RecordTypeId=recordType,Area__c=300
        );
        insert product1;

        Product2 product2 = new Product2(
            Name='Premise2', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland', RecordTypeId=recordType, Area__c=300
        );
        insert product2;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true,
            ValidFrom__c = Date.newInstance(2010, 12, 9),
            ValidTo__c = Date.newInstance(2028, 12, 12)
        );
        
        update standardPricebook;

        insert new PriceBookEntry(Product2Id=product1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);
        PriceBookEntry pricebookEntry = new PriceBookEntry();
        pricebookEntry.Product2Id = product1.id;
        pricebookEntry.PriceBook2Id = pricebook.id;
        pricebookEntry.IsActive=true;
        pricebookEntry.UnitPrice=100.0;

        insert pricebookEntry;
        pricebookExistingEntriesList.add(product1);

        Test.startTest();
        result = RE_pricebookExplorerController.addRecordsToPricebook(pricebook.id, JSON.serialize(pricebookExistingEntriesList));
        Test.stopTest();

        System.assertEquals(result, true);
    }

    @isTest
    static void checkIfFunctionReturnsRecordsByRecordType() {

        List<PriceBookEntry> pricebookInfo;
        Boolean result;

        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2)pricebooks[0];

        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        Product2 product = new Product2(
             Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland', RecordTypeId=recordType, Area__c=300
        );

        insert product;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true,
            ValidFrom__c = Date.newInstance(2010, 12, 9),
            ValidTo__c = Date.newInstance(2028, 12, 12)
        );
        
        update standardPricebook;

        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);

        PriceBookEntry pricebookEntry = new PriceBookEntry();
        pricebookEntry.Product2Id = product.id;
        pricebookEntry.PriceBook2Id = pricebook.id;
        pricebookEntry.IsActive=true;
        pricebookEntry.UnitPrice=100.0;
        pricebookEntry.UseStandardPrice=false;

        insert pricebookEntry;

        Test.startTest();
        pricebookInfo = RE_pricebookExplorerController.getRecordsByRecordType(PREMISE_NAME);
        Test.stopTest();

        System.assertNotEquals(pricebookInfo, null);
    }

    @isTest
    static void checkIfPricebookIsAddedToDatabase() {

        Boolean result;
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();

        String pbName ='Pricebook1';
        String pbDesc ='Pricebook1';
        Date pbStartDay = Date.newInstance(2016, 12, 9);
        Date pbEndDay = Date.newInstance(2016, 12, 11);
        Pricebook2 pricebook = RE_pricebookExplorerController.createPricebook(pbName,pbDesc, pbStartDay, pbEndDay);
       
        List<Product2> products = Test.loadData(Product2.sObjectType, 'sample_Product2');
        Product2 product = (Product2)products[0];

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
        result = RE_pricebookExplorerController.addPricebookToDatabase(pbName, pbDesc, pbStartDay, pbEndDay, JSON.serialize(pricebookInfo));
        Test.stopTest();

        System.assertEquals(result, true);
    }

    @isTest
    static void shouldUpdatePricebookDateActive() {

        Boolean result;
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();

        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2)pricebooks[0];
       
        List<Product2> products = Test.loadData(Product2.sObjectType, 'sample_Product2');
        Product2 product = (Product2)products[0];

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
        result = RE_pricebookExplorerController.updatePricebookDateActive(pricebook.id, Date.newInstance(2010, 12, 9), Date.newInstance(2010, 12, 12));
        Test.stopTest();

        System.assertEquals(result, true);
    }
    @isTest
    static void shouldNotUpdatePricebookDateActive() {

        Boolean result;
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();

        // List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        // Pricebook2 pricebook = (Pricebook2)pricebooks[0];
       
        Pricebook2 pricebook = new Pricebook2(
            Name='Pricebook1', 
            ValidFrom__c = Date.newInstance(2022, 10, 10),
            ValidTo__c = Date.newInstance(2022, 12, 12)
        );

        insert pricebook;

        Pricebook2 pricebook2 = new Pricebook2(
            Name='Pricebook1', 
            ValidFrom__c = Date.newInstance(2022, 11, 10),
            ValidTo__c = Date.newInstance(2022, 12, 10)
        );

        insert pricebook2;

        List<Product2> products = Test.loadData(Product2.sObjectType, 'sample_Product2');
        Product2 product = (Product2)products[0];

        insert new PriceBookEntry(Product2Id=product.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0);

        PriceBookEntry pricebookEntry = new PriceBookEntry();
        pricebookEntry.Product2Id = product.id;
        pricebookEntry.PriceBook2Id = pricebook.id;
        pricebookEntry.IsActive=true;
        pricebookEntry.UnitPrice=100.0;
        pricebookEntry.UseStandardPrice=false;

        insert pricebookEntry;

        PriceBookEntry pricebookEntry2 = new PriceBookEntry();
        pricebookEntry2.Product2Id = product.id;
        pricebookEntry2.PriceBook2Id = pricebook2.id;
        pricebookEntry2.IsActive=true;
        pricebookEntry2.UnitPrice=100.0;
        pricebookEntry2.UseStandardPrice=false;

        insert pricebookEntry2;

        pricebookInfo.add(pricebookEntry);

        Test.startTest();
        try{
            result = RE_pricebookExplorerController.updatePricebookDateActive(pricebook.id, Date.newInstance(2022, 12, 9), Date.newInstance(2022, 12, 12));
        } catch (Exception ex) {
            System.Assert(ex.getMessage().contains('There is already a pricebook'));
        }  
        Test.stopTest();
    }
}
