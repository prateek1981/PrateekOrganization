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
    public static String uploadFiles(String filename, String file64){
        String methodName = 'POST';
        String endPoint = 'callout:SalesforceToSalesforce/services/apexrest/myEndpoint';
        String body = '"filename": "'+filename+'" , "file": "'+file64+'"';
        HttpRequest req = new HttpRequest();
        req.setMethod(methodName);
        req.setEndpoint(endPoint);
        req.setBody(body);

        Http ht = new Http();
        HttpResponse res = ht.send(req);
        system.debug(res.getBody());
        System.debug(res.getStatusCode());
       if(res.getStatusCode() == 200){
            return 'Upload Success';
       }
        return 'upload fail';
    }
}
