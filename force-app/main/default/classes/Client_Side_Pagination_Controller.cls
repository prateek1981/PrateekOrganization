public with sharing class Client_Side_Pagination_Controller {
   
    @AuraEnabled(cacheable=true)
    public static List<ObjectClass> fetchObject() {
        String lab=system.Label.StandardObjectsCustomLabels;
        System.debug('Apex method is running');
        Map<String, Schema.SObjectType> mobjects = Schema.getGlobalDescribe();
        List<ObjectClass> objList = new List<ObjectClass>();
        for (String s : mobjects.keySet()) {
            Schema.DescribeSObjectResult sobjectDescribe = mobjects.get(s).getDescribe();
            if (sobjectDescribe.isCustom() ||lab.contains(mobjects.get(s).getDescribe().getLabel()) ) {
                objList.add(new ObjectClass(s, sobjectDescribe.getLabel()));
            }
        }
        System.debug('Objects list is'+objList);
        return objList;
    }
    @AuraEnabled (cacheable=true)
    public static List<FieldClass> fetchFields(String objname){
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        objectsMap=Schema.getGlobalDescribe();

        Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
        Schema.SObjectType obj=objectsMap.get(objname);
        fieldsMap=obj.getDescribe().fields.getMap();
        List<FieldClass> fieldList=new List<FieldClass>();
        
        
        for(String fieldNam:fieldsMap.keySet()){
            if(fieldsMap.get(fieldNam).getDescribe().isCreateable() && fieldsMap.get(fieldNam).getDescribe().isFilterable()  || fieldsMap.get(fieldNam).getDescribe().isCustom() || fieldsMap.get(fieldNam).getDescribe().isAutoNumber() || fieldsMap.get(fieldNam).getDescribe().isNameField()){
                fieldList.add(new FieldClass(fieldNam,fieldsMap.get(fieldNam).getDescribe().getLabel()));
               
            }
        }
        System.debug('Value of field list is'+fieldList);
       return fieldList;
    }
    @AuraEnabled(cacheable=true)
    public static List<WrapRecord> fetchRecords(String selectedObject, List<String> fSelected){
        System.debug('Object value in fetchRecords method is'+selectedObject);
        System.debug('fetchData method is called');
        String query='Select Id,'+String.join(fSelected,', ')+' From '+selectedObject;
        System.debug(Query);
        List<SObject> records;
        try {
            records= Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('Records=>>>>>>>>>>>>>>>>>>>'+records);
        List<WrapRecord> wrapperList=new List<WrapRecord>();
        for(SObject rec:records){
            WrapRecord wr=new WrapRecord(false, rec);
            wrapperList.add(wr);
        }

        return wrapperList;
    }
    public class FieldClass{
        @AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public String fieldLabel {get;set;}

        public FieldClass(String name, String label){
            fieldName=name;
            fieldLabel=label;
        }
    }
    @AuraEnabled
    public static List<String> fetchFieldsApi(List<String>fselected,String objname){
        System.debug('fetchFieldApi method is called');
        Map <String,String>fMap=new Map<String,String>();
        List<String> fieldApiList=new List<String>();
        try {
            

            Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
            objectsMap=Schema.getGlobalDescribe();
    
            Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
            Schema.SObjectType obj=objectsMap.get(objname);
            fieldsMap=obj.getDescribe().fields.getMap();
            
            
            
            for(String fieldNam:fieldsMap.keySet()){

                Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldNam).getDescribe();
                if ((fieldDescribe.isCreateable() && fieldDescribe.isFilterable()) || fieldDescribe.isCustom() || fieldDescribe.isAutoNumber() || fieldDescribe.isNameField()) {
                    if (fselected.contains(fieldNam)) {
                        fieldApiList.add(fieldDescribe.getName());
                    }
                }

            }

           for(String str:fMap.keySet()){
                fieldApiList.add(fMap.get(str));
           }
           system.debug('FieldApiList is'+fieldApiList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return fieldApiList;
    }

    public class ObjectClass {
        @AuraEnabled public String objectName { get; set; }
        @AuraEnabled public String objectLabel { get; set; } 
        
        public ObjectClass(String name, String label) {
            objectName = name;
            objectLabel = label;
        }
    }
    public class WrapRecord{
        @AuraEnabled public Boolean checkbox{get; set;}
        @AuraEnabled public SObject records{get;set;}
        public WrapRecord(Boolean check, SObject rec){
            checkbox=check;
            records=rec;
        }
    }

}