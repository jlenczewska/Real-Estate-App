@isTest
private class RE_filePreviewAndDownloadControllerTest {

    @isTest
    static void checkIfSavesAnImageAsDefault() {
        Boolean result = RE_saveImageAsMainImage.saveImageAsDefault('01t7Q000003t05fQAA', '');

        System.assertNotEquals(result, true);
    }

    @isTest
    static void checkIfFunctionCreateCorrectUrl() {
        Boolean result = RE_saveImageAsMainImage.saveImageAsDefault('01t7Q000003t05fQAA', '01t7Q000003t05fQAA');

        System.assertNotEquals(result, true);
    }
}