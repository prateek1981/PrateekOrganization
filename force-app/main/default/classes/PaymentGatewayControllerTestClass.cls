@isTest
public with sharing class PaymentGatewayControllerTestClass {
   @isTest
   public static void payByAuthrizePaymentTest(){
    //Test.setMock(HttpCalloutMock.class, new PaymentGatewayCalloutMockTest());
   	Test.startTest();
    String fname='Prateek';
    String lname='Shekhawat';
    String cardNumber='4111111111111111';
    String amount='500';
    String cmonth='August';
    String cyear='2025';
    String cvv='1212';
    //PaymentGatewayController.payByAuthrizePayment(fname,lname,cardNumber,amount,cmonth,cyear,cvv);
    Test.stopTest();
   }
    @isTest
    public static void payByEcheckTest(){
        String rnumber='072403004';
        String anumber='4111111111111111';
        String cname='Prateek';
      //  PaymentGatewayController.payByEcheck(rnumber,anumber,cname);
    }
}