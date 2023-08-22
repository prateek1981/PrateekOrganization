public with sharing class PaymentGatewayService {
    public static String payByAuthrizePaymenService(String r){
        System.debug('Service paybyauthorize method is running');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(r);
        System.debug(r);
        HttpResponse res = new HttpResponse();
        res = h.send(req);
        String responseBody = res.getBody();
        System.debug('Response is '+responseBody);
        System.debug('Status code is '+res.getStatusCode());
        if(responseBody.contains('"description":"This transaction has been approved."') || responseBody.contains('"description":"Your order has been received. Thank you for your business!"')){
            return 'This transaction has been approved.';
        }
        else{
            return 'Not Approved';
        }
    }
    public static String payByEcheckService(String r){
        System.debug('Service payByEcheckService method is running');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(r);
        HttpResponse res = new HttpResponse();
        res = h.send(req);
        if(String.IsNotBlank(res.getBody())){
            system.debug(res.getBody());
        }
        System.debug('Status code is '+res.getStatusCode());
        System.debug('response of echeck is '+res);
        String responseBody = res.getBody();
        if(responseBody.contains('"description":"This transaction has been approved."') || responseBody.contains('"description":"Your order has been received. Thank you for your business!"')){
            return 'This transaction has been approved.';
        }
        else{
            return 'Not Approved';
        }
    }
}