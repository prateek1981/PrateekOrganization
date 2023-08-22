public class TriggerAssignmentCases {
  	public  map<Account,map<Decimal,Contact>> ConMap;
    public static  Integer triggercall=0;
    List <contact> dummy;
    public Integer size;
    public Integer consize;
    Integer reverse=0;
    List<Contact> listcon;
    public static Boolean prevent_rec=false;
    List<Contact> contactsofaccount=new List<Contact>();
    List<Contact>xyz=new List<Contact>();
    Boolean Condition=false;
     Set<ID> idset;
     Set<ID> newID;
    Static Integer numtimes=0;
     List <Contact> chunk=new List<Contact>();
     public TriggerAssignmentCases(){
             ConMap=new map<Account,map<Decimal,Contact>>();
        }
    /*---------------------------------------------*/
  	
     public void insertcase(List<Contact> newContacts){
        
        Set<Id> accountIds = new Set<Id>();
        for (Contact con : newContacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        List<Contact> oldcontacts = [SELECT Id, AccountId, Sr_Number__c FROM Contact WHERE AccountId IN :accountIds];
        Map<Id, List<Contact>> mapcon = new Map<Id, List<Contact>>();
        for(Id accId : accountIds){
            mapcon.put(accId, new List<Contact>());
        }

        for(Contact con : oldcontacts){
            if(accountIds.contains(con.AccountId)){
                mapcon.get(con.AccountId).add(con);
            }
        }

        for (Contact con : newContacts) {
            if(con.AccountId!= null){
                if(con.Sr_Number__c > mapcon.get(con.AccountId).size() || con.Sr_Number__c == null){
                con.Sr_Number__c = mapcon.get(con.AccountId).size()+1;
                mapcon.get(con.AccountId).add(con);
            }                               
            else{
                for(Contact existCon : mapcon.get(con.AccountId)){
                    if(existCon.Sr_Number__c >= con.Sr_Number__c){
                        existCon.Sr_Number__c++ ;
                    }
                }
                mapcon.get(con.AccountId).add(con);
            }
            }
            
        }
        if(!oldcontacts.isEmpty()){
            update oldcontacts;
        }
        prevent_rec=false;
    }
    public void  deletecase(){
        Boolean condition=false;
        List<Contact> finallist=new List<Contact>();
         List<Account> acc=new List<Account>();
   
             acc=[SELECT ID,(SELECT Name,Sr_Number__C FROM Contacts) FROM ACCOUNT ];
        
        
        for(Account a:acc){
          if(!ConMap.containsKey(a))
          {
          	ConMap.put(a,new map<Decimal,Contact>());
          } 
           for(Contact conta:a.Contacts){
              if(!ConMap.get(a).ContainsKey(conta.sr_Number__c)){
             		ConMap.get(a).put(conta.sr_Number__C,new Contact());
              }		     
              ConMap.get(a).get(conta.SR_Number__c).id=conta.id;
          }
        }
        for(Account a:ConMap.keySet()){
            dummy=new List<contact>();
            Integer temp=1;
            for(Integer i=0;;i++){
                if(ConMap.get(a).containskey(temp)){
                    dummy.add(ConMap.get(a).get(temp)); 
                }
                if(a.contacts.size()==dummy.size()){
                    break;
                }
                temp++;
            }
            ConMap.put(a,new Map<Decimal,Contact>());
            temp=1;
            for(Contact conta:dummy){
                conta.SR_Number__c=temp;
                temp++;
                finallist.add(conta);
              	if(!ConMap.get(a).ContainsKey(conta.sr_Number__c)){
             		ConMap.get(a).put(conta.sr_Number__C,new Contact());
              }		     
              ConMap.get(a).get(conta.SR_Number__c).id=conta.id;
          }
            dummy.clear();
            
   	   } 
         prevent_rec=false;
        update finallist;
       
    }
    public void undeletecase(List<Contact> c){
      	List<Contact> clist=new List<Contact>();
        List <Contact> finallist=new List<Contact>();
        finallist=new List<Contact>();
        dummy=new List<Contact>();
        Set<ID> Conid=new Set<Id>();
        Set<ID> Acid=new Set<Id>();
        for(Contact cont:c){
            Conid.add(cont.id);
        }
        List <Contact> co=[SELECT ID,Accountid FROM Contact WHERE ID IN: Conid];
        for(Contact a:co){
            Acid.add(a.Accountid);
        }
        List<Contact> cntct=[SELECT ID,AccountId FROM Contact];
        List<Account> ac=[SELECT ID From Account WHERE Id In : Acid];
        for(Account a:ac){
          if(!ConMap.containsKey(a))
          {
          	ConMap.put(a,new map<Decimal,Contact>());
          }    
            
          for(Contact conta:a.Contacts){
              newid.add(conta.id);
              if(!ConMap.get(a).ContainsKey(conta.sr_Number__c)){
             		ConMap.get(a).put(conta.sr_Number__C,new Contact());
              }		     
              ConMap.get(a).get(conta.SR_Number__c).id=conta.id;
          }
            Integer totalcontacts=1;
            for(Contact tempcon:cntct){
                if(tempcon.Accountid==a.id){
                    totalcontacts++;
                }
            }
            Integer decrement=2;
            Integer increament=1;
            for(Contact cont:co){
                if(cont.AccountId==a.id){
                    Contact temp=new Contact(Id=cont.id);
                    temp.sr_Number__C=totalcontacts+increament-decrement;
                    dummy.add(temp);
                    increament++;
                    decrement=decrement+2;
                    finallist.add(temp);
                }
            }
            dummy.clear();
        }
        update finallist;
        prevent_rec=false;
    }

        public static void contactsUpdated(List <Contact> newConList, List<Contact> oldConList) {
            Map<Id,List<Contact>> conAllMap = new Map<Id,List<Contact>>(); 
            Set<Id> accIdSet = new Set<Id>();
            Set<Id> conIdSet = new Set<Id>();
            Map<Id,Integer> newSequenceMap = new Map<Id,Integer>();
            Map<Id,Id> oldAccIdMap = new Map<Id,Id>();
            Map<Id,Contact> oldContactMap = new Map<Id,Contact>();
            for(Contact con : oldConList) {
                accIdSet.add(con.AccountId);
                oldAccIdMap.put(con.Id, con.AccountId);
            }
            for(Contact con : newConList) {
                if(!accIdSet.contains(con.AccountId)) {
                    accIdSet.add(con.AccountId);
                }
                conIdSet.add(con.Id);
                newSequenceMap.put(con.Id,(Integer)con.Sr_Number__c);
            }
            for(Id accId : accIdSet) {
                conAllMap.put(accId, new List<Contact>());
            }
            List<Contact> conAllList = [SELECT ID, AccountId, Sr_Number__c, Name FROM Contact WHERE AccountID IN : accIdSet ORDER BY Sr_Number__c];
            List<Contact> conListWithoutUpdated = [SELECT ID, AccountId, Sr_Number__c, Name FROM Contact WHERE AccountID IN : accIdSet AND Id NOT IN : conIdSet ORDER BY Sr_Number__c]; //AllContacts
    
            for(Contact con : conAllList) {
                oldContactMap.put(con.Id,con);
            }
            for(Contact con : conListWithoutUpdated) {
                conAllMap.get(con.AccountId).add(con);
            }
    
            for(Contact con : newConList) {
                if(oldAccIdMap.get(con.Id) != con.AccountId) {
                    conAllMap.get(con.AccountId).add(oldContactMap.get(con.Id));
                } 
             else if(con.Sr_Number__c >= 1 && con.Sr_Number__c < conAllList.size()) {
                    conAllMap.get(con.AccountId).add(newSequenceMap.get(con.Id)-1,oldContactMap.get(con.Id));
                } else {
                    conAllMap.get(con.AccountId).add(oldContactMap.get(con.Id));
                }
            }
            
            for(Contact con : conAllList) {
                con.Sr_Number__c = conAllMap.get(con.AccountId).indexOf(oldContactMap.get(con.Id)) + 1;
            }
            for(Contact con : newConList) {
                con.Sr_Number__c=conAllMap.get(con.AccountId).indexOf(oldContactMap.get(con.Id)) + 1;
                for(Integer i=0;i<conAllList.size();i++) {
                    if(con.Id==conAllList[i].id) {
                        conAllList.remove(i);
                    }
                }
            }
            update conAllList;
        }
}