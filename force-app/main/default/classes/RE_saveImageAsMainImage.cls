public with sharing class RE_saveImageAsMainImage {

    public static Boolean saveImageAsDefault(String recordId, String urlPhoto, String urlDisplay) {
          
        try {
            Product2 product = [SELECT Picture__c, DisplayUrl FROM Product2 WHERE Id=:recordId];
            product.Picture__c = urlPhoto;
            product.DisplayUrl = urlDisplay;
            update product;
            return true;
        } catch (Exception e) {
            return false;
        }
    }
 
    @AuraEnabled
    public static Boolean getImageUrlAndSaveAsDefaultImage(String photoId, String recordId) {

        ContentVersion filesVersion = [SELECT Id, ContentDocumentId,VersionData FROM ContentVersion WHERE ContentDocumentId=:photoId LIMIT 1];
        String linkPhoto = '';
        ContentDistribution cDist = [SELECT ContentDownloadUrl, ContentVersionId FROM ContentDistribution WHERE ContentVersionId=:filesVersion.id LIMIT 1];
        String versionID = String.valueOf(filesVersion.id);
        linkPhoto = 'https://britenet28-dev-ed.file.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=' + versionID.substring(0,versionID.length()-3) + '&operationContext=CHATTER&contentId=' + filesVersion.ContentDocumentId;
        
        return saveImageAsDefault(recordId, linkPhoto, cDist.ContentDownloadUrl);
    }
}