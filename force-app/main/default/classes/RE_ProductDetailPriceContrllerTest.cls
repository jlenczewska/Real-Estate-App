@isTest
public with sharing class RE_ProductDetailPriceContrllerTest {
    
    @isTest
    static void shouldGetProductPrice() {

        Decimal result;
        List<PriceBookEntry> pricebookInfo = new List<PriceBookEntry>();

        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name ='Pricebook1';
        pricebook.ValidFrom__c = Date.newInstance(2016, 12, 9);
        pricebook.ValidTo__c = Date.newInstance(2016, 12, 11);
        pricebook.isactive = true;
        insert pricebook;
        
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
        result = RE_ProductDetailPriceContrller.getProductPrice(product.id);
        Test.stopTest();

        System.assertEquals(result, pricebookEntry.UnitPrice);
    }
}
