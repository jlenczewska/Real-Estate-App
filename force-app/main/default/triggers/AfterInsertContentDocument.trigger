trigger AfterInsertContentDocument on ContentDocumentLink(after insert) {
    List<ContentDocumentLink> newDocuments = Trigger.new;

    if(newDocuments.size()>1){
        ContentDocumentLink newDocument = newDocuments[1];
        List<ContentDocumentLink> cdl = [
            SELECT Visibility, contentdocument.id, contentdocument.title, contentdocument.filetype
            FROM contentdocumentlink
            WHERE LinkedEntityId = :newDocument.LinkedEntityId
        ];
    
        Set<Id> cdlIds = new Set<Id>();
    
        List<ContentDistribution> allContentDist = [SELECT ContentDocumentId, PdfDownloadUrl, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution];
        Set<Id> allContentDistIds = new Set<Id>();
    
        for (ContentDistribution cd : allContentDist) {
            allContentDistIds.add(cd.ContentDocumentId);
        }
    
        for (ContentDocumentLink c : cdl) {
            if (!allContentDistIds.contains(c.contentdocument.id)) {
                cdlIds.add(c.contentdocument.id);
            }
            c.Visibility = 'AllUsers';
        }
        update cdl;
    
        List<ContentVersion> cvs = [SELECT id FROM contentversion WHERE contentdocumentid IN :cdlIds];
        List<ContentDistribution> cd = new List<ContentDistribution>();
    
        for (ContentVersion cv : cvs) {
            ContentDistribution contentDist = new ContentDistribution(
                Name = 'PublicShare',
                ContentVersionId = cv.id,
                PreferencesAllowViewInBrowser = true,
                PreferencesLinkLatestVersion = true,
                PreferencesNotifyOnVisit = false,
                PreferencesPasswordRequired = false,
                PreferencesAllowOriginalDownload = true
            );
            cd.add(contentDist);
        }
    
        insert cd;
    }
    
}
