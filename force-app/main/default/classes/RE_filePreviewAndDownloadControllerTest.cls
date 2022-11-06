@isTest
public class RE_filePreviewAndDownloadControllerTest {

    public static final String PREMISE_NAME = 'Apartment';

    @isTest
    static void checkIfReturnsNotNullMap() {
     
        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        Product2 picture = new Product2(
            Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',RecordTypeId = recordType,Country__c='Poland'
       );

       insert picture;

        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = '0697Q000004TIrHQAW';
        cDocLink.LinkedEntityId = picture.id;
        cDocLink.ShareType = 'I';
        cDocLink.Visibility = 'AllUsers';
       
        insert cDocLink;
 
        Map<ID, String> resultMap = new Map<ID, String>();
     
        Test.startTest();
        resultMap = RE_filePreviewAndDownloadController.getRelatedFilesByRecordId(picture.id);
        Test.stopTest();

        System.assertEquals(resultMap.size(), 1);
    }
}