public with sharing class RE_ApartmentJourneyController {
    
    @AuraEnabled
    public static Product2 getProductData(String recordId) {
        return [SELECT Id, DisplayUrl, Street__c, City__c, Country__c FROM Product2 WHERE Id = :recordId];
    }
}
