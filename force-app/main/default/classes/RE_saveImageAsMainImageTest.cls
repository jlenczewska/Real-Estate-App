@isTest
public class RE_saveImageAsMainImageTest {

    @isTest
    static void checkIfFunctionCreateCorrectUrl() {
        
        Boolean result;

        String photoId = '0697Q000004TIr';
        String recordId = '0697Q000004TIr';

        ContentVersion contentV = new ContentVersion();
        contentV.ContentDocumentId = '0697Q000004TIr';
        contentV.Title='tytul';
        contentV.ContentLocation = 'S';
        contentV.PathOnClient = '.png';
        contentV.IsMajorVersion = true;
        contentV.VersionData = EncodingUtil.base64Decode('aaa');
      
        insert contentV;

        Product2 picture = new Product2(
             Name='Premise', Street__c='Nowacka 11', City__c='B',Picture__c='AAA',Country__c='Poland'
        );
 
        insert picture;

        Test.startTest();
        result = RE_saveImageAsMainImage.getImageUrlAndSaveAsDefaultImage(photoId, recordId);
        Test.stopTest();

        System.assertEquals(result, false);
    }
}