@RestResource(urlMapping='/myEndpoint/*')
global with sharing class MyEndpointClass {
    @HttpGet
    global static List<ContentDocument> getContentDocumentsByLoggedInUser() {
        String contactId = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :contactId];
        
        Set<Id> documentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            documentIds.add(link.ContentDocumentId);
        }
        List<ContentDocument> contentDocuments = [SELECT Id, Title, FileType, FileExtension, ContentModifiedDate FROM ContentDocument WHERE Id IN :documentIds];
        
        return contentDocuments;
    }
}
