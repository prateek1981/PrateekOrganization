public class MyContactListController {
 @AuraEnabled  
    public static List<Contact> getContacts(ID recordId){
        
       return [SELECT ID, FirstName, LastName, Email, Phone FROM Contact WHERE AccountID = :recordId];
    }
}