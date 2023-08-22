public class ContactAndLeadSearch{
    public static List<List< sObject>> searchContactsAndLeads(String s){
        List<List<sObject>> objectList=[Find :s in ALL FIELDS RETURNING 
                                       Contact(FirstName,LastName),Lead(FirstName,LastName)];
        return objectList;
    
    }
}