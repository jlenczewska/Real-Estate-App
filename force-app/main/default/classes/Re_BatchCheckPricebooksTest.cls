@isTest
public with sharing class Re_BatchCheckPricebooksTest {
    
    @isTest
    public static void shouldUpdateRecord(){
        List<Pricebook2> pricebooks = new List<Pricebook2>();

        Pricebook2 pricebook = new Pricebook2(
            Name = 'Pricebook',
            ValidFrom__c = Date.today(), 
            ValidTo__c = Date.today(),
            IsActive = false
        );

        insert pricebook;
       
        pricebooks.add(pricebook);

        Test.startTest();
        Re_BatchCheckPricebooks batch = new Re_BatchCheckPricebooks();
        Database.executeBatch(batch,200);
        Test.stopTest();
        Pricebook2 pb = [SELECT id, isActive FROM Pricebook2 WHERE id=:pricebook.Id];
        system.assertEquals(pb.isActive, true);
    }
}
