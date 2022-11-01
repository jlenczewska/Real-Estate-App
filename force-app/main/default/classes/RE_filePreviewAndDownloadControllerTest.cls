@isTest
public class RE_filePreviewAndDownloadControllerTest {

    @isTest
    static void checkIfReturnsNotNullMap() {
     
        String photoId = '0697Q000004TIrHQAB';
        String recordId = '0697Q000004TIrHQAH';


        Product2 product = new Product2(
            Name='Premise'
       );

       insert product;

        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = '0697Q000004TIrHQAW';
        cDocLink.LinkedEntityId = product.id;
        cDocLink.ShareType = 'I';
        cDocLink.Visibility = 'AllUsers';
       
        insert cDocLink;
 
        Map<ID, String> resultMap;
     
        Test.startTest();
        resultMap = RE_filePreviewAndDownloadController.getRelatedFilesByRecordId('01t7Q000003t05fQAA');
        Test.stopTest();

        System.assertEquals(resultMap.size(), 0);
    }
}