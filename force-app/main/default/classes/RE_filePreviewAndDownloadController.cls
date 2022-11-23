public with sharing class RE_filePreviewAndDownloadController {

    public static final String PROFILE_COMMUNITY_USER = 'Customer Community User';
  
    @AuraEnabled
    public static Boolean editShouldBeAvailable() {
      Id profileId = UserInfo.getProfileId();
      if (profileId != null) {
        String profileName = [SELECT Id, Name FROM Profile WHERE Id = :profileId].Name;
        return profileName == PROFILE_COMMUNITY_USER ? false: true;
      }
      return true;
    }

    @AuraEnabled
    public static String getDisplayImage(String selectedElementId) {
        String resultUrl;
        List<ContentDistribution> url = [SELECT ContentDocumentId,ContentDownloadUrl,PdfDownloadUrl,DistributionPublicUrl FROM ContentDistribution];

        for(ContentDistribution singleUrl: url){
            if(singleUrl.ContentDocumentId == selectedElementId){
                resultUrl = singleUrl.DistributionPublicUrl;
                break;
            }
        }
        return resultUrl;
    }

        @AuraEnabled(cacheable=true)
        public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
                
            try{
                List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
                List<ID> fileIDs = new List<ID>();
                for (ContentDocumentLink docLink : files) {
                    fileIDs.add(docLink.ContentDocumentId);
                }
         
                List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                    FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
                Map<ID, String> mapIdTitle = new Map<ID, String>();
                for (ContentVersion docLink : docs) {
                    mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
                }
                return mapIdTitle;
            }
            catch(Exception e){
                return null;
            }
            
        }
}