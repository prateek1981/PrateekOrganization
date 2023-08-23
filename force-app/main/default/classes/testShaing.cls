@isTest
public with sharing class testShaing  {
    @isTest(SeeAllData=true)
    public static void testSharingMethod(){
        //This is a comment
        User v1 = [SELECT ID FROM User where Username= 'prateek.1212@briskminds.com'];
        System.runAs(v1){
            System.debug('Without sharing-'+ ShareWithoutSharing.account_Count());
            System.debug('With sharing-'+ ShareWithSharing.account_Count());
        }
    }
}