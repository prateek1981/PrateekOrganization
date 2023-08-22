public with sharing class LWCAccountContactsFlow {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String contactId){
        List<Contact> conList=[SELECT Id,Name,Phone,Email From Contact Where AccountId=:contactId];
        return conList;
    }
}