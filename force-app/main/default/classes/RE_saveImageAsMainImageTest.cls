@isTest
public class RE_saveImageAsMainImageTest {

    @isTest
    static void checkIfFunctionCreateCorrectUrl() {
        
        Boolean result;

        String photoId = '0697Q000004TIrH';
        String recordId = '0697Q000004TIrH';

        ContentVersion ContentDoc = new ContentVersion();
        ContentDoc.Title = 'My Doc';
        ContentDoc.ContentUrl= 'test.com';
        ContentDoc.ContentDocumentId = photoId;
        Insert ContentDoc;

        Product2 product = new Product2(
            Name='Premise', City__c='Poland', Country__c='Poland', Street__c='Poland', Picture__c='abc'
        );
 
        insert product;

        Test.startTest();
        result = RE_saveImageAsMainImage.getImageUrlAndSaveAsDefaultImage(photoId, recordId);
        Test.stopTest();

        System.assertEquals(result, false);
    }
}