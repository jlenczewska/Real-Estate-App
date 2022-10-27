@isTest
private class RE_filePreviewAndDownloadControllerTest {

    @isTest
    static void checkIfReturnsNotNullMap() {
        Map<ID, String> resultMap= RE_filePreviewAndDownloadController.getRelatedFilesByRecordId('01t7Q000003t05fQAA');
        System.assertNotEquals(resultMap.size(), 0);
    }
}