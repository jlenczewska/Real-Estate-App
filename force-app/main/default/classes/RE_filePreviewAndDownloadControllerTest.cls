@isTest
public class RE_filePreviewAndDownloadControllerTest {

    @isTest
    static void checkIfReturnsNotNullMap() {
     
        String photoId = '0697Q000004TIrHQAB';
        String recordId = '0697Q000004TIrHQAH';


        Product2 picture = new Product2(
            Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',RecordTypeId = '0127Q000001gDcWQAU',Country__c='Poland'
       );

       insert picture;

        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = '0697Q000004TIrHQAW';
        cDocLink.LinkedEntityId = picture.id;
        cDocLink.ShareType = 'I';
        cDocLink.Visibility = 'AllUsers';
       
      //AllUsers, InternalUsers, SharedUsers
        insert cDocLink;

      
 
        Map<ID, String> resultMap;
     
        Test.startTest();
        resultMap = RE_filePreviewAndDownloadController.getRelatedFilesByRecordId('01t7Q000003t05fQAA');
        Test.stopTest();

        System.assertEquals(resultMap.size(), 0);
    }
}