public with sharing class RE_saveImageAsMainImage {

    static Boolean saveImageAsDefault(String recordId, String url) {
        Product2 product = [SELECT Picture__c FROM Product2 WHERE Id=:recordId];
        product.Picture__c = url;

        Boolean result;
        try {
            update product;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        return result;
    }

    @AuraEnabled
    public static Boolean getImageUrlAndSaveAsDefaultImage(String photoId, String recordId) {

    List<ContentVersion> filesVersions = [SELECT ContentDocumentId,VersionData FROM ContentVersion];
    String link = '';

    for (ContentVersion version : filesVersions) {
        if(version.ContentDocumentId == photoId){
            String versionID = String.valueOf(version.id);
            link = 'https://britenet28-dev-ed.file.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=' + versionID.substring(0,versionID.length()-3) + '&operationContext=CHATTER&contentId=' + version.ContentDocumentId;
        }
    }
    
    Boolean success = saveImageAsDefault(recordId, link);
    return success;

    }
}
