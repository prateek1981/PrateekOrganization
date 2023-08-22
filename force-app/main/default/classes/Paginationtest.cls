@istest
public class Paginationtest {   
    @istest public static void testdetails(){
       Pagination ma=new Pagination();
        ma.details();
    }
    @istest public static void testshow(){
       Pagination ma=new Pagination();
       ma.show();
        System.assertEquals(false, ma.condition);     
    }
    @istest public static void testresetall(){
        Pagination ma=new Pagination();
        ma.resetall();
       	System.assertEquals('None', ma.selectedobj);
            }
    @istest public static void testresetshowcomponent(){
        Pagination ma=new Pagination();
        ma.resetshowcomponent();
        
    }
    @istest public static void testresetCheck(){
        Pagination ma=new Pagination();
        ma.resetCheck();
        System.assertEquals(false,ma.check);
        System.assertEquals(true,ma.tick);
    }
    @istest public static void testremoveFields(){
        Pagination ma=new Pagination();
        ma.removeFields();
    }
    @istest public static void testresetFieldList(){
        Pagination ma=new Pagination();
        ma.ResetFieldsList();
    }
    @istest public static void testaddFields(){
        Pagination ma=new Pagination();
        ma.addFields();
    }
    @istest public static void testresetcheckforadd(){
        Pagination ma=new Pagination();
        ma.resetcheckforadd();
    }
}