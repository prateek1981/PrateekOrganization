public with sharing class DateTimeFormula {
    @AuraEnabled(cacheable=true)
    public static string changeDateTime(Id recid){
        System.debug('Apex method is called');
        System.debug('Record id is '+recid);
        List<Account>accList=[SELECT id,Dummy_Date__c FROM Account WHERE id=:recid];
        accList[0].Dummy_Date__C.addHours(2);
      
        System.debug('The updated date and time is '+accList[0].Dummy_Date__C);
        update accList;
        return 'updated';
    }
}