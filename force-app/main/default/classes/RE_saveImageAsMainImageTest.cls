@isTest
public class RE_saveImageAsMainImageTest {

    public static final String PREMISE_NAME = 'Apartment';

    @isTest
    static void checkIfFunctionCreateCorrectUrl() {
        
        Boolean result;

        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        Product2 product = new Product2(
            Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',RecordTypeId = recordType,Country__c='Poland', Area__c=300
       );

       insert product;

       ContentVersion contentVersion = new ContentVersion(
        Title = 'a picture',
        PathOnClient = 'Pic.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true
        );
        
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = product.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;

        Test.startTest();
        result = RE_saveImageAsMainImage.getImageUrlAndSaveAsDefaultImage(cdl.ContentDocumentId, product.id);
        Test.stopTest();

        System.assertEquals(result, true);
    }
}