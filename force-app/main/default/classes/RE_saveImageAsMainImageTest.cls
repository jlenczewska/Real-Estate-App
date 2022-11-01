@isTest
public class RE_saveImageAsMainImageTest {

    @isTest(SeeAllData=true)
    static void checkIfSavesAnImageAsDefault() {
        Boolean result = RE_saveImageAsMainImage.saveImageAsDefault('01t7Q000003t05fQAA', '');

        System.assertEquals(result, false);
    }

    @isTest(SeeAllData=true)
    static void checkIfFunctionCreateCorrectUrl() {
        Boolean result = RE_saveImageAsMainImage.getImageUrlAndSaveAsDefaultImage('01t7Q000003t05fQAA', '01t7Q000003t05fQAA');

        System.assertEquals(result, false);
    }
}