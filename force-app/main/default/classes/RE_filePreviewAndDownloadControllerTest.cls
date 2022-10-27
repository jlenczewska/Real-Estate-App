@isTest
public class RE_filePreviewAndDownloadControllerTest {

    @isTest(SeeAllData=true)
    static void checkIfReturnsNotNullMap() {
        Map<ID, String> resultMap= RE_filePreviewAndDownloadController.getRelatedFilesByRecordId('01t7Q000003t05fQAA');
        System.assertEquals(resultMap.size(), 0);
    }
}