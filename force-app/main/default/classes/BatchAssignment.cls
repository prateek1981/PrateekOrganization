global class BatchAssignment implements Database.Batchable<SObject>,Schedulable {
    public List<contact> contactlist;
    String header;

    
        public BatchAssignment(){
            contactlist=new List<contact>();
        }
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT ID,LastName,Status__C,Act_Date__C,EndDate__C FROM Contact Where CreatedDate = YESTERDAY]);
    }
    global void execute(Database.BatchableContext bc, List<Contact> conlist){
     
        for (Contact con: conlist){
            con.Status__c='Ready for approval';
        }
        update conList;
    }
    global void finish(Database.BatchableContext bc){  
        contactList = [SELECT ID,LastName,Status__C,Act_Date__C,EndDate__C,Description FROM Contact Where CreatedDate = YESTERDAY];
        header = 'Record Id, Name ,Status ,Activated Date ,End Date ,Description \n';
        for(Contact con: contactList)
        {
               header += con.id+','+con.LastName+','+con.Status__c+','+con.Act_Date__c+','+con.EndDate__c+','+Json.serialize(con.Description) +'\n';
        }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(header);
        csvAttc.setFileName('Contact.csv');
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'prateek.singh@briskminds.com'};
        email.setSubject('Contact CSV');
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Contact CSV');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
    global void execute(SchedulableContext sc){
        BatchAssignment ba=new BatchAssignment();
		Database.executeBatch(ba);
    }
}