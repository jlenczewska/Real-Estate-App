global with sharing class Re_BatchCheckPricebooks implements Database.Batchable<sObject> {
  global Database.QueryLocator start(Database.BatchableContext bc) {
      return Database.getQueryLocator('SELECT ID, ValidFrom__c, ValidTo__c, IsActive, IsStandard FROM Pricebook2 WHERE IsStandard=false');
  }
  global void execute(Database.BatchableContext bc, List<Pricebook2> scope) {
      List<Pricebook2> pricebooks = new List<Pricebook2>();
      for (Pricebook2 pricebook : scope) {
          if (pricebook.ValidFrom__c == Date.today()) {
              pricebook.IsActive = true;
          }
          if (pricebook.ValidTo__c < Date.today()) {
              pricebook.IsActive = false;
          }
          pricebooks.add(pricebook);
      }
      update pricebooks;
  }
  global void finish(Database.BatchableContext bc) {
  }
}
