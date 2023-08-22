public with sharing class PaymentGatewayController {
    @AuraEnabled
    public static String payByAuthrizePayment(String firstName, String lastName, String cardNumber, String amount, String cardMonth, String cardYear, String cvv){
        System.debug('Apex is running');
        String email = 'prateek.singh@briskminds.com';
        String fullName = firstName + ' ' + lastName;
        String phone = '9999999999'; 
        String loginId = ' 84VefT2zuAP'; 
        String transactionKey = '3Y94nMbX5f7SAy3W';
        JSONGenerator payBody = JSON.createGenerator(true);
        payBody.writeStartObject();
        payBody.writeFieldName('createTransactionRequest');
         
        payBody.writeStartObject();
        payBody.writeFieldName('merchantAuthentication');
         
        payBody.writeStartObject();
        payBody.writeStringField('name', loginId);
        payBody.writeStringField('transactionKey', transactionKey);
        payBody.writeEndObject();
         
        payBody.writeStringField('refId', '123456');
        payBody.writeFieldName('transactionRequest');
         
        payBody.writeStartObject();
        payBody.writeStringField('transactionType', 'authCaptureTransaction');
        payBody.writeStringField('amount', amount);
        payBody.writeFieldName('payment');
         
        payBody.writeStartObject();
        payBody.writeFieldName('creditCard');
         
        payBody.writeStartObject();
        payBody.writeStringField('cardNumber', cardNumber);
        payBody.writeStringField('expirationDate', cardYear + '-' + cardMonth);
        payBody.writeStringField('cardCode', cvv);
        payBody.writeEndObject();
         
         
        payBody.writeEndObject();
         
        payBody.writeFieldName('customer');
        payBody.writeStartObject();
        if(String.isNotBlank(email)){
            payBody.writeStringField('email', email);    
        }
        payBody.writeEndObject();
        payBody.writeEndObject();
        payBody.writeEndObject();
        payBody.writeEndObject();
        
        String str=PaymentGatewayService.payByAuthrizePaymenService(payBody.getAsString());
        return str;
    }
   @auraEnabled
     public static String payByEcheck(String routingNumber, String accountNumber, String cardName){
        System.debug('PaybyEcheck called');
        String email = 'prateek.singh@briskminds.com';
        String phone = '7976959527';
        String loginId = '84VefT2zuAP';
        String transactionKey = '3Y94nMbX5f7SAy3W';
        System.debug('Rounting number is '+routingNumber);
        System.debug('Account number is '+accountNumber);
        System.debug('Card name is '+cardName);
             
        JSONGenerator payBody = JSON.createGenerator(true);
        payBody.writeStartObject();
        payBody.writeFieldName('createTransactionRequest');
         
        payBody.writeStartObject();
        payBody.writeFieldName('merchantAuthentication');
         
        payBody.writeStartObject();
        payBody.writeStringField('name', loginId);
        payBody.writeStringField('transactionKey', transactionKey);
        payBody.writeEndObject();
         
        payBody.writeStringField('refId', '123456');
        payBody.writeFieldName('transactionRequest');
         
        payBody.writeStartObject();
         
        payBody.writeStringField('transactionType', 'authCaptureTransaction');
         
        payBody.writeStringField('amount', '100');
         
        payBody.writeFieldName('payment');
         
        payBody.writeStartObject();
        payBody.writeFieldName('bankAccount');
         
        payBody.writeStartObject();
        payBody.writeStringField('accountType', 'checking');
        payBody.writeStringField('routingNumber', routingNumber);
        payBody.writeStringField('accountNumber', accountNumber);//4111111111111111
        payBody.writeStringField('nameOnAccount', cardName);
        payBody.writeStringField('bankName', '');
        payBody.writeStringField('checkNumber', '');
        payBody.writeEndObject();
         
        payBody.writeEndObject();
         
        payBody.writeFieldName('customer');
        payBody.writeStartObject();
        if(String.isNotBlank(email)){
            payBody.writeStringField('email', email);
        }
         
        payBody.writeEndObject();
        payBody.writeEndObject();
        payBody.writeEndObject();
        payBody.writeEndObject();
    
        String str=PaymentGatewayService.payByEcheckService(payBody.getAsString());
        return str;
    }
}