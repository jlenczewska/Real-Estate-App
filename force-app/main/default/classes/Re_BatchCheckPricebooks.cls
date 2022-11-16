public with sharing class Re_BatchCheckPricebooks implements
Database.Batchable < sObject > ,
Database.Stateful {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator('SELECT ID, ValidFrom__c, ValidTo__c, IsActive, IsStandard FROM Pricebook2 WHERE IsStandard=false');
  }
  public void execute(Database.BatchableContext bc, List < Pricebook2 > scope) {
    List < Pricebook2 > pricebooks = new List < Pricebook2 > ();
    for (Pricebook2 pricebook: pricebooks) {
      if (pricebook.ValidFrom__c == Date.today()) {
        pricebook.IsActive = true;
      }
      if (pricebook.ValidTo__c < Date.today()) {
        pricebook.IsActive = false;
      }
    }
    update pricebooks;
  }
  public void finish(Database.BatchableContext bc) {
  }
}