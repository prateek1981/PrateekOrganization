public class Server_Side_Pagination {
    @AuraEnabled
    public static Map<String,String> giveObjects(){
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
                fieldList.add(fieldsMap.get(fieldNam).getDescribe().getLabel());
                filterFiledMap.put(fieldsMap.get(fieldNam).getDescribe().getName(), fieldsMap.get(fieldNam).getDescribe().getLabel());
            }
        }
        return filterFiledMap;
    }
    
    @AuraEnabled
    public static WrapData fatchData(List<String> flist,String objname, Integer psize,Integer pNumber,String flow,String forder,List<ID> selectId){
		Set<ID> checkboxList=new Set<ID>();
        List<SObject> recordsList=new List<SObject>();
        Integer startfrom;
        Integer endfrom;

        String totalStr='Select Id,'+String.join(flist,', ')+' From '+objname+' Order By '+forder+' '+flow ;

        List<SObject> allRecordList=Database.query(totalStr);
        System.debug(allRecordList);
        
        startfrom=pNumber*psize;
        endfrom=(pNumber+1)*psize;
        if(endfrom>=allRecordList.size()){
            endfrom=allRecordList.size();
        }
        
        for(Integer i=0;i<selectId.size();i++){
                checkboxList.add(selectId[i]);
        }
        for(Integer i=startfrom;i<endfrom;i++){
            recordsList.add(allRecordList[i]);
        }
        WrapData tempdata=new WrapData();
        tempdata.totalrec=allRecordList.size();
        tempdata.dataList=recordsList;
        tempdata.cbox=checkboxList;
        return tempdata;
    }


    public class WrapData {
       
        @AuraEnabled
        public Set<ID> cbox {get;set;}
        @AuraEnabled
        public List<SObject> dataList {get;set;}
        @AuraEnabled
        public Integer totalrec {get;set;}
        
    }
}