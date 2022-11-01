@isTest
public class RE_saveImageAsMainImageTest {

    @isTest
    static void checkIfFunctionCreateCorrectUrl() {
        
        Boolean result;

        String photoId = '0697Q000004TIrH';
        String recordId = '0697Q000004TIrH';

        ContentVersion contentV = new ContentVersion();
        contentV.ContentDocumentId = '0697Q000004TIrH';
        contentV.Title='tytul';
        contentV.ContentLocation = 'S';
        contentV.PathOnClient = '.png';
        contentV.IsMajorVersion = true;
        contentV.VersionData = EncodingUtil.base64Decode('aaa');
      
        insert contentV;

        Product2 product = new Product2(
             Name='Premise'
        );
 
        insert product;

        Test.startTest();
        result = RE_saveImageAsMainImage.getImageUrlAndSaveAsDefaultImage(photoId, recordId);
        Test.stopTest();

        System.assertEquals(result, false);
    }
}