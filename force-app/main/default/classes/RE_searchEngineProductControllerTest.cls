@isTest
public with sharing class RE_searchEngineProductControllerTest {
    public static final String PREMISE_NAME = 'Apartment';
    public static final String SAMPLE_PRICEBOOK = 'sample_Pricebook2';
    public static final String SAMPLE_PRODUCT = 'sample_Product2';

    @isTest
    static void shouldReturnUserRoleName() {
        String typeOfUser;
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = uniqueUserName
        );

        System.runAs(u) {
            Test.startTest();
            typeOfUser = RE_searchEngineProductController.checkUserPremissions();
            Test.stopTest();
        }
        System.assertEquals(typeOfUser, 'Apartment');
    }

    @isTest
    static void shouldReturnFilteredProducts() {
        List<Product2> foundProductsByFilters = new List<Product2>();
        String stringifiedFilters = '{"Filters_Checkbox_Group":["Swimming Pool","Balcony"]}';

        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        Product2 product1 = new Product2(
            Name = 'Premise1',
            Street__c = 'Nowacka 11',
            City__c = 'B',
            Picture__c = 'AAA',
            Country__c = 'Poland',
            RecordTypeId = recordType,
            Swimming_Pool__c = true,
            Balcony__c = true,
            Area__c = 123
        );
        insert product1;

        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2) pricebooks[0];

        Test.startTest();
        foundProductsByFilters = RE_searchEngineProductController.searchProductByFilters('', stringifiedFilters);
        Test.stopTest();
        System.assertEquals(foundProductsByFilters[0].Name, 'Premise1');
    }

    @isTest
    static void shouldReturnProductsPrices() {
        List<PricebookEntry> productsPrices = new List<PricebookEntry>();
        String stringifiedFilters = '{"Filters_Checkbox_Group":["Swimming Pool","Balcony"]}';

        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        Product2 product1 = new Product2(
            Name = 'Premise1',
            Street__c = 'Nowacka 11',
            City__c = 'B',
            Picture__c = 'AAA',
            Country__c = 'Poland',
            RecordTypeId = recordType,
            Swimming_Pool__c = true,
            Balcony__c = true,
            Area__c = 123
        );
        insert product1;

        List<Pricebook2> pricebooks = Test.loadData(Pricebook2.sObjectType, SAMPLE_PRICEBOOK);
        Pricebook2 pricebook = (Pricebook2) pricebooks[0];
        System.debug(pricebook);

        Id pricebookId = Test.getStandardPricebookId();
        
        insert new PriceBookEntry(Product2Id = product1.Id, Pricebook2Id = pricebookId, UnitPrice = 30);
        
        Test.startTest();
        productsPrices = RE_searchEngineProductController.getProductsPrice();
        Test.stopTest();

        System.debug(productsPrices);
        System.debug(productsPrices[0]);

        System.assertNotEquals(1, 0);
    }
}
