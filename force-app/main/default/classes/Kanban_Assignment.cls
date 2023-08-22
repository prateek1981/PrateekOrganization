public class Kanban_Assignment {
	@auraEnabled public static Map<String,String> giveObjects(){
        Map<String, Schema.SObjectType> mobject=new Map<String, Schema.SObjectType>();								// Contains all the SObjectType as a Map
        
        Map<String, String> ObjMap = new Map<String, String>();														// Contains Map of Object Name and Label
        List<String> objList=new List<String>();	
        String lab=system.Label.StandardObjectsCustomLabels;													// It is a custom label in which objects that support 
        																											// standard set controller are stored
        mobject=Schema.getGlobalDescribe();													
        for (String tempobj : mobject.keySet()) {
            
            if(lab.contains(mobject.get(tempobj).getDescribe().getLabel()) || mobject.get(tempobj).getDescribe().isCustom() ){
                    objList.add(mobject.get(tempobj).getDescribe().getLabel());
                    
                    ObjMap.put(tempobj, mobject.get(tempobj).getDescribe().getLabel());
            }
        }
        objList.sort();
        return ObjMap;
	}
    @AuraEnabled
    public static Map<String,String> inputfields(String objname){
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        objectsMap=Schema.getGlobalDescribe();

        Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
        Schema.SObjectType obj=objectsMap.get(objname);
        fieldsMap=obj.getDescribe().fields.getMap();
        
        List<String> fieldList=new List<String>();
        Map<String, String> filterFiledMap = new Map<String, String>();
        for(String fieldNam:fieldsMap.keySet()){
            if(fieldsMap.get(fieldNam).getDescribe().isCreateable() && fieldsMap.get(fieldNam).getDescribe().isFilterable()  || fieldsMap.get(fieldNam).getDescribe().isCustom() || fieldsMap.get(fieldNam).getDescribe().isAutoNumber() || fieldsMap.get(fieldNam).getDescribe().isNameField()){
                if (fieldsMap.get(fieldNam).getDescribe().getType() == Schema.DisplayType.Picklist) {
                    fieldList.add(fieldsMap.get(fieldNam).getDescribe().getLabel());
                    filterFiledMap.put(fieldsMap.get(fieldNam).getDescribe().getName(), fieldsMap.get(fieldNam).getDescribe().getLabel());
            }
               
            }
        }
        return filterFiledMap;
    }
    @AuraEnabled
    public static List<String> picklistValues(String objname,String sfield){
       List <String> values=new List<String>();
        Schema.DescribeFieldResult fieldresult= Schema.getGlobalDescribe().get(objname).getDescribe().fields.getMap().get(sfield).getDescribe();
        for (Schema.PicklistEntry entry : fieldresult.getPicklistValues()) {
    	  values.add(entry.getValue());
    	}
        return values;
    }
    
    @AuraEnabled
    public static Map<String,List<sObject>> getKanbanWrap(String objName,String sfield) {
        System.debug('I am enter in get kanban wrap');
		List <String> values=new List<String>();
        Map<String,List<SObject>> recMap=new Map<String,List<SObject>>();
        
        Schema.DescribeFieldResult fieldresult= Schema.getGlobalDescribe().get(objname).getDescribe().fields.getMap().get(sfield).getDescribe();
        for (Schema.PicklistEntry entry : fieldresult.getPicklistValues()) {
    	  values.add(entry.getValue());
    	}
        
        String query = 'SELECT Id, Name';
        String q;
        query = query.removeEnd(',');
        query += ' FROM ' + objName;
       
        for(String str:values){
            if(!recMap.containsKey(str)){
                recMap.put(str, new List<sObject>());
            }
             q='SELECT Name, '+sfield+' FROM '+objName +' WHERE '+sfield+' =:  str';
            recMap.get(str).addAll(Database.query(q));
         
        }
        return recMap;
    }
    
    @AuraEnabled
    public static String getUpdateStage(Id recId, String kanbanField, String kanbanNewValue) {
        SObject o1 = recId.getSObjectType().newSObject(recId);
        o1.put(kanbanField,kanbanNewValue);
        update o1;
        system.debug('Update method running');
        return 'Success';
    }
     @AuraEnabled
    public static kanbanWrap getKanbanData(String objName,String sfield) {
        System.debug('I am enter in get getkanbandata function');
		List <String> values=new List<String>();
        Schema.DescribeFieldResult fieldresult= Schema.getGlobalDescribe().get(objname).getDescribe().fields.getMap().get(sfield).getDescribe();
        for (Schema.PicklistEntry entry : fieldresult.getPicklistValues()) {
    	  values.add(entry.getValue());
    	}
        String query = 'SELECT Id, Name';
        query = query.removeEnd(',');
        query += ' FROM ' + objName;
        KanbanWrap kw= new kanbanWrap(Database.query(query), values);
        System.debug('This is KanbanData>>>>>>>>>>>>>>>>>>>>'+kw);
        return kw;
    }
    
    @AuraEnabled
    public static Integer gettotal(String objname, String objfield, String pickval){
        System.debug('gettotal is running');
        List<Sobject> temp=new List<Sobject>();
        temp=Database.query('SELECT COUNT() FROM '+objname +' WHERE '+objfield+' = '+ ':'+pickval);
        String str='SELECT COUNT() FROM '+objname +' WHERE '+objfield+' = '+ ':'+pickval;
        System.debug('The query in the gettotal is >>>>>>>>>>>>>.'+str);
        Integer num=temp.size();
        return num;
    }
    
    public class kanbanWrap{
        @AuraEnabled
        public List<sObject> records {get;set;}
        @AuraEnabled
        public List<String> pickVals {get;set;}
        
        public kanbanWrap(List<sObject> recs, List<String> pVals){
            this.records = recs;
            this.pickVals = pVals;
        }
    }
    
}