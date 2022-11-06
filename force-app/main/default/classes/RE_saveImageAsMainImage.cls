public with sharing class RE_saveImageAsMainImage {

    public static Boolean saveImageAsDefault(String recordId, String url) {
          
        try {
            Product2 product = [SELECT Picture__c FROM Product2 WHERE Id=:recordId];
            product.Picture__c = url;
            update product;
            return true;
        } catch (Exception e) {
            return false;
        }
    }
 
    @AuraEnabled
    public static Boolean getImageUrlAndSaveAsDefaultImage(String photoId, String recordId) {

    ContentVersion filesVersion = [SELECT ContentDocumentId,VersionData FROM ContentVersion WHERE ContentDocumentId=:photoId LIMIT 1];
    String link = '';

    String versionID = String.valueOf(filesVersion.id);
    link = 'https://britenet28-dev-ed.file.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=' + versionID.substring(0,versionID.length()-3) + '&operationContext=CHATTER&contentId=' + filesVersion.ContentDocumentId;
    
    return saveImageAsDefault(recordId, link);
    }
}