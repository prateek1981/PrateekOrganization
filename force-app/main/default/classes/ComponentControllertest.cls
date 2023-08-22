@istest
public class ComponentControllertest {
    @istest 
    static public void testgetquery(){
        ComponentController ob=new ComponentController ();
        Account ac=new Account();
        ac.name='TestClass';
        ac.Phone='4533223232';
        Set<String> fieldset=new Set<String>();
        ob.fieldselect.add(ac.name);
        ob.fieldselect.add(ac.phone);
 		String query='SELECT ID FROM Account WHERE NAME=TestClass';   
        Apexpages.StandardSetController st=new Apexpages.StandardSetController(Database.getQueryLocator([SELECT NAME FROM Account WHERE NAME='TestClass']));
        ob.setcon=st;
        ob.query();
        System.assertNotEquals(ob.setcon, null);
        
    }
    @istest public static  void testLast(){
        ComponentController ob=new ComponentController ();
        ob.Last();
    }
    @istest public static void testPageJump(){
        ComponentController ob=new ComponentController ();
        ob.PageJump();
    }
    @istest public static void testfirst(){
        ComponentController ob=new ComponentController ();
        ob.First();
    }
    @istest public static void testalphabeticmethod(){
        ComponentController ob=new ComponentController ();
        ob.alphabeticmethod();
        ob.selectedobject='Case';
        ob.Alphabet='All';
    }
    @istest public static void testCSVDownload(){
        ComponentController ob=new ComponentController ();
        ob.CSVDownlaod();
    }
     @istest public static void testSortColumn(){
        ComponentController ob=new ComponentController ();
        ob.SortColumn();
    }
    @istest public static void testcreate(){
        ComponentController ob=new ComponentController ();
        ob.create();
    }
    @istest public static void testrecordSize(){
        ComponentController ob=new ComponentController ();
        ob.recordSize();
    }
    @isTest public static void testdeleteselectedrecord(){
        Account ac=new Account();
        ac.name='TestClass';
        ac.Phone='4533223232';
        ComponentController ob=new ComponentController ();
        ob.idSet.add(ac.id);
        ob.deleteselectedrecord();
    }
     @isTest public static void testprevious(){
        ComponentController ob=new ComponentController ();
        ob.previous();
    
    }
    @isTest public static void testMastercheckBox(){
        ComponentController ob=new ComponentController ();
        ob.masterCheckBox();
    }
    @isTest public static void testNext(){
        
        ComponentController ob=new ComponentController ();
        ob.Next();
    }
    @isTest public static void testinit(){
        ComponentController ob=new ComponentController ();
        ob.init();
    }
    @isTest public static void deleterecordstest(){
         Account ac=new Account();
        ac.name='TestClass';
        ac.Phone='4533223232';
        
        ComponentController ob=new ComponentController ();
        ob.records.add(ac);
        ob.deleterecords();
       
        String query='SELECT NAME FROM Account WHERE ID IN:ob.idset';
        List<sObject> sObjectList = Database.query(query);
        delete sObjectList;
    }
}