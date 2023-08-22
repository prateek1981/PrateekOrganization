@isTest
public class TestTriggerAssignment {
    @isTest public static  void  testinsertCase(){
        List<Contact> conlist=new List<Contact>();
        for(Integer i=0;i<10;i++){
            Contact con=new Contact(LastName='Test'+i, AccountId='0012w00001VO5O3');
			conlist.add(con);                
        }
        Contact con=new Contact(LastName='demooo',SR_Number__c=3,AccountId='0012w00001VO5O3');
		conlist.add(con);
        insert conlist;
        
        TriggerAssignmentCases ta=new TriggerAssignmentCases();
        ta.insertcase(conlist);
    }
    @isTest public static void testDeleteCase(){
        
        List<Account> acclist=TestDataFactory.getAccounts(10);
        Map<Account,Map<Decimal,Contact>> conmap=TestDataFactory.getmap();
        TriggerAssignmentCases ta=new TriggerAssignmentCases();
        ta.deletecase();
    }
    @isTest public static void testUndeleteCase(){
        List<Contact> conlist=new List<Contact>();
        Map<Account,map<Decimal,Contact>> conmap=new Map<Account,map<Decimal,Contact>>();
        for(Integer i=0;i<10;i++){
            Contact con=new Contact(LastName='Test'+i, AccountId='0012w00001VO5O3');
			conlist.add(con);                
        }
      /*  Account aco=new Account(Name='Test');
        conmap.put(aco,new Map<Decimal,Contact>());*/
        insert conlist;
        delete conlist;
        
        undelete conlist;
        TriggerAssignmentCases ta=new TriggerAssignmentCases();
        ta.undeletecase(conlist);
    }
    @isTest public static void testUpdateCase(){
        List<contact> newcon=new List<Contact>();
      //  List<Account> acclist=[SELECT ID,(SELECT Name,Sr_Number__C FROM Contacts) FROM ACCOUNT];
        
        for(Contact con:[SELECT ID,SR_Number__c FROM Contact Where CreatedDate=today]){
            con.SR_Number__c=2;
            newcon.add(con);
        }
        update(newcon);   
 		List<Contact> oldcon=[SELECT ID,SR_Number__c FROM Contact Where CreatedDate!=today];
        //TriggerAssignmentCases ta=new TriggerAssignmentCases();
        TriggerAssignmentCases.contactsUpdated(newcon,oldcon);
    }
}