@isTest
public class KanbanTest {
    @isTest public static void getPicklistValuesTest(){
        String Obj='Account';
        String field='Rating';
        KanbanController.getPicklistValues(Obj,field);
    }
    @isTest public static void getRecordsTest(){
        String Obj='Account';
        String field='Rating';
        KanbanController.getRecords(Obj,field);
    }
}