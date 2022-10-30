public with sharing class RE_pricebookManagerController {

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getRecordsByRecordType(String premiseName) {

        List<Object> result = new List<Object>();
        List<String> productsOfRecordType = new List<String>();
        List<PricebookEntry> productListResults = new List<PricebookEntry>();

        if(premiseName.length() == 0){
            return productListResults;
        }

        RecordType recordTypeInfo = [SELECT Name, Id FROM RecordType WHERE Name =: premiseName];
        List<Product2> productList = [SELECT Id, RecordTypeId, Name FROM Product2 WHERE RecordTypeId =: recordTypeInfo.Id];

        for(Product2 product: productList){
            productsOfRecordType.add(product.Id);
        }

       Pricebook2 priceBook = [SELECT id, name FROM Pricebook2 WHERE Name = 'Standard Price Book'];
       List<PricebookEntry> listOfPriceBookEntries = [SELECT Id, Product2Id, Name, UnitPrice FROM PricebookEntry WHERE Pricebook2Id=:priceBook.Id];


       for(PricebookEntry product: listOfPriceBookEntries){
        if(productsOfRecordType.contains(product.Product2Id)){
            productListResults.add(product);
        }
       }
        return productListResults;
    }

public static Pricebook2 createPricebook(String pbName, String pbDesc, Date pbStartDay, Date pbEndDay){
   
    try {
        Pricebook2 newPricebook = new Pricebook2();
        newPricebook.Name = pbName;
        newPricebook.Description = pbDesc;
        newPricebook.ValidFrom__c = pbStartDay;
        newPricebook.ValidTo__c = pbEndDay;
        newPricebook.IsActive = true;
        Database.insert(newPricebook,false);

        return newPricebook;
    }

    catch (Exception e) {
        return null;
    }
}   

    @AuraEnabled
    public static Boolean addPricebookToDatabase(String pbName, String pbDesc, Date pbStartDay, Date pbEndDay, String pricebookEntries) {

        Pricebook2 pricebook = createPricebook(pbName, pbDesc, pbStartDay, pbEndDay);
        List<PricebookEntryWrapper> entryList = (List<PricebookEntryWrapper>) JSON.deserialize(pricebookEntries, List<PricebookEntryWrapper>.class);
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();

        Map<Id, PricebookEntry> productMap = new Map<Id, PricebookEntry>(
            [SELECT Id, Product2Id FROM PricebookEntry]
        );

        for(PricebookEntryWrapper entry: entryList){
            String productID = productMap.get(entry.Id).Product2Id;
            pricebookEntryList.add(new PricebookEntry(UnitPrice = entry.UnitPrice, Pricebook2Id = pricebook.id, product2Id = productID, isActive = true));
        }

        try{
            Database.insert(pricebookEntryList,true);
            return true;
        }
        catch(Exception e){
            return false;
        }
    }

    class PricebookEntryWrapper {
        Decimal UnitPrice;
        String Id;
    }
}