@isTest
global class PaymentGatewayCalloutMockTest implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response=new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"filenames":["Prateek"]}');
        response.setStatusCode(200);
        return response;
    }
}