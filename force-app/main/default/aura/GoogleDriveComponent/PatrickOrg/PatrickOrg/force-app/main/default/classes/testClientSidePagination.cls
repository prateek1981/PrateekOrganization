@isTest
public class testClientSidePagination {
	@isTest public static void testFetchObject(){
        Client_Side_Pagination_Controller.fetchObject();
     //   csp.fetchObject();
    }
    @isTest public static void testFetchFields(){
        String acc='Account';
        Client_Side_Pagination_Controller.fetchFields(acc);
    }
    @isTest public static void testFetchRecords(){
        String obj='Account';
        List<String> str=new List<String>{'Id','Name'};
        Account testAccount = new Account(Name = 'Test Account');
         List<Client_Side_Pagination_Controller.WrapRecord> recordList = Client_Side_Pagination_Controller.fetchRecords(obj, str);
        System.assertEquals(1, recordList.size());
        Client_Side_Pagination_Controller.WrapRecord wrapRecord = new Client_Side_Pagination_Controller.WrapRecord(false, testAccount);
        System.assertEquals(false, wrapRecord.checkbox);
        System.assertEquals(testAccount, wrapRecord.records);
       
    }
    @isTest public static void testFieldApi(){
        String obj='Account';
        Account acc=new Account(Name='Test Account');
        insert acc;
        List<String> str=new List<String>{'Id','Name'};
        
        Client_Side_Pagination_Controller.fetchFieldsApi(str,obj);
        
    }
}