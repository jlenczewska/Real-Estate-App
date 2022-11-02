public with sharing class RE_pricebookExplorerController {

    @AuraEnabled
    public static List<Pricebook2> getPricebooks(String searchPhrase) {

        List<Pricebook2> pricebooksList;
        String queryPhrase = String.escapeSingleQuotes(searchPhrase) + '%';

        if(searchPhrase.trim().length() > 0){
            pricebooksList = [SELECT Id, Name FROM Pricebook2 WHERE Name LIKE :queryPhrase];
        }
        else{
            pricebooksList = [SELECT Id, Name FROM Pricebook2];
        }
        
        return pricebooksList;
    }

    @AuraEnabled
    public static List<PriceBookEntry> getPricebookInfo(String pricebookId) {

        List<PriceBookEntry> pricebookInfo = [SELECT Id, Name, Product2Id,Product2.Name, PriceBook2Id, PriceBook2.Name, UnitPrice FROM PriceBookEntry WHERE PriceBook2Id=:pricebookId];
        
        return pricebookInfo;
    }

    @AuraEnabled
    public static Boolean updatePricebook(String pricebookId, String pricebookEntries) {

        List<PricebookEntryWrapper> entryList = (List<PricebookEntryWrapper>) JSON.deserialize(pricebookEntries, List<PricebookEntryWrapper>.class);
        List<PriceBookEntry> pricebookInfo = [SELECT Product2Id, UnitPrice FROM PriceBookEntry WHERE PriceBook2Id=:pricebookId];
        
        Map<Id, Decimal> pricebookEntities = new Map<Id, Decimal>();

        for(PricebookEntryWrapper entry: entryList){
            pricebookEntities.put(entry.Id, entry.UnitPrice);
        }

        for(PriceBookEntry entry: pricebookInfo){
            entry.unitPrice = pricebookEntities.get(entry.Product2Id);
        }
        
        try{
            Database.update(pricebookInfo,false);
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