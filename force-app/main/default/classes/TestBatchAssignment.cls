@isTest
public class TestBatchAssignment {
    @isTest	public static void Class_Test_Method(){
		List<Contact> conlist=TestDataFactory.getcontactRecords(10);
        System.debug(conlist.size());
		BatchAssignment bc=new BatchAssignment();
		Database.executeBatch(bc);        
    }
}