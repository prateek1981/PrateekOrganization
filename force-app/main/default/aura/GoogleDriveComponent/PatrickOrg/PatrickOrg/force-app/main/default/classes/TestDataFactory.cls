@isTest
public class TestDataFactory {
    public Static void getAccounts(Integer num){
        List<Account> acc=new List<Account>();
        for(Integer i=1;i<=10;i++){
            Account a=new Account(Name='Test'+i);
            acc.add(a);
        }
        insert acc;
       
    }
    public Static void getcontacts(Integer num){
        Integer temp=1;
        Account ac1=new Account(Name='Accounttest');
        Account ac2=new Account(Name='Accounttest2');
        List<Account> acclist=new List<account>();
        acclist.add(ac1);
        acclist.add(ac2);
        insert acclist;
        List<contact> conlist=new List<contact>();
        for(Account acco:acclist){
            for(Integer i=1;i<=num;i++){
                Contact con=new Contact(LastName='PrateekRocks'+i,AccountId=acco.id,SR_Number__c=temp);
                conlist.add(con);
                temp++;
                System.debug('Account id is getting printed>>>>>'+acco.id);
        	}
        }
        insert conlist;
     
        
    }
    
    public Static void getupdatedContacts(Integer num){
        List<Contact> cont=[SELECT ID ,SR_Number__C FROM Contact];
        Integer temp=1;
        for(Contact con:cont){
            con.SR_Number__c=temp++;
        }
        update cont;

    }
    public Static  void getcontactrecords(Integer num){
        List<contact> conlist=new List<Contact>();
        for(Integer i=1;i<=num;i++){
            Contact con=new Contact(LastName='Testing'+i);
            conlist.add(con);
        }   
        insert conlist;
       
    }
}