@isTest
public class RE_filePreviewAndDownloadControllerTest {

    @isTest
    static void checkIfReturnsNotNullMap() {
     
        String photoId = '0697Q000004TIrHQAB';
        String recordId = '0697Q000004TIrHQAH';


        Product2 product = new Product2(
            Name='Premise', City__c='Poland', Country__c='Poland', Street__c='Poland'
       );

       insert product;

       ContentVersion ContentDoc = new ContentVersion();
       ContentDoc.Title = 'My Doc';
       ContentDoc.ContentUrl= 'test.com';
       Insert ContentDoc;

       ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :ContentDoc.Id];
       
       ContentDocumentLink ContentDL = new ContentDocumentLink();
       ContentDL.ContentDocumentId = testcontent.contentdocumentid;
       ContentDL.LinkedEntityId = product.id;
       Insert ContentDL;
 
        Map<ID, String> resultMap;
     
        Test.startTest();
        resultMap = RE_filePreviewAndDownloadController.getRelatedFilesByRecordId(product.id);
        Test.stopTest();

        System.assertEquals(resultMap.size(), 1);
    }
}