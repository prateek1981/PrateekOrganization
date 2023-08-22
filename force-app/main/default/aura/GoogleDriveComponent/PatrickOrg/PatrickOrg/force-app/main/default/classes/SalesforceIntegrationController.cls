public with sharing class SalesforceIntegrationController {
    @AuraEnabled
    public static String showAllFiles() {
        System.debug('showAllFiles method is called');
        String endpointUrl = 'callout:SalesforceToSalesforce/services/apexrest/myEndpoint';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointUrl);
        request.setMethod('GET');

        HttpResponse response = new HttpResponse();
        Http http = new Http();
        response = http.send(request);   
        system.debug('File data is '+response.getBody());    
        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            return null; 
        }
    }
    @AuraEnabled
    public static void uploadedTheFiles(String fileName, String fileid){
    System.debug('uploaded files method is called');
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:SalesforceToSalesforce/services/apexrest/myEndpoint');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json');
    Map<String, Object> requestBody = new Map<String, Object>();
    requestBody.put('fileName', fileName);
    requestBody.put('fileContent', fileid);
    request.setBody(JSON.serialize(requestBody));
    HttpResponse response = new Http().send(request);
    if (response.getStatusCode() == 200) {
       System.debug('file uploaded succesfully');
    } else {
        System.debug('file could not be uploaded');
    }
    }
}