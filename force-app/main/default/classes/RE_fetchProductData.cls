public with sharing class RE_fetchProductData {

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getRecordsByRecordType(String premiseName) {

        List<Object> result = new List<Object>();

        // RecordType recordTypeInfo = [SELECT Name, Id FROM RecordType WHERE Name =: premiseName];
        // List<Product2> productList = [SELECT RecordTypeId, Name FROM Product2 WHERE RecordTypeId =: recordTypeInfo.Id];

        Pricebook2 priceBook = [SELECT id, name FROM Pricebook2 WHERE Name = 'Standard Price Book'];
       List<PricebookEntry> listOfPriceBookEntries = [Select Name, UnitPrice from PricebookEntry where Pricebook2Id=:priceBook.Id];

        // result.addAll(list1);
        // result.addAll(list2);

        return listOfPriceBookEntries;
    }
}
