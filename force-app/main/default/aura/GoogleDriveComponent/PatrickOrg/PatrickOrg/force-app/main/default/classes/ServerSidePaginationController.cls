public class ServerSidePaginationController {
    @AuraEnabled 
    public static Integer getRecordCount(String objName ){
        String query = 'SELECT ID FROM '+objName;
        List<SObject> recordC = Database.query(query);
        return recordC.size();
    }
    @AuraEnabled
    public static Map<String,String> getAllObject(){
        List<String> standardControllerObj = System.Label.StandardObjectsCustomLabels.Split(',');
        Map<String,String> returnObjectMap = new Map<String,String>();
        Map<String , Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        for(Schema.SObjectType sObj : objectmap.Values()){
            Schema.DescribeSObjectResult result = sObj.getDescribe();
            if(result.isCustom() || standardControllerObj.contains(result.getLabel())){
                String key = sObj.getDescribe().getName();
                String value = sObj.getDescribe().getLabel();
                returnObjectMap.put(key , value);
            } 
        }
        return returnObjectMap;
    }
    @AuraEnabled
    public static Map<String,String> getAllField(String objectName){
        Map<String,String> returnFieldsMap = new Map<String,String>();
        List<String> allFields = new List<String>();
        Map<String , Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        SObjectType sObjType = objectMap.get(objectName);
        Map<String, Schema.sObjectField> objTypeFields = sObjType.getDescribe().fields.getMap();
        if(! objTypeFields.isEmpty()){
            for(String fieldName : objTypeFields.keySet()){
                Schema.DescribeFieldResult res = objTypeFields.get(fieldName).getDescribe();
                if(res.isCalculated() || res.isCustom() || res.isAutoNumber() || res.isUnique() || res.isCreateable() || res.isCaseSensitive()){
                   returnFieldsMap.put(String.valueOf(res.getName()),String.valueOf(res.getLabel()));
                }
            }
        } 
        return returnFieldsMap;
    }
    @AuraEnabled
	public static List<sObject> getRecords(String objectName, List<String> selectedFields , Integer limitSize , Integer currentPage ) {
    	List<Map<String, Object>> records = new List<Map<String, Object>>();
        Double count = 0 ;
        String  query = 'SELECT ID  FROM '+objectName+' ORDER BY ID ';
        List<sObject> listOfRecords = Database.query(query);
        count = Math.ceil(listOfRecords.size() / limitSize);
    	String queryString = 'SELECT ';
    	for (String field : selectedFields) {
        	queryString += field + ', ';
    	}
    	queryString = queryString.substring(0, queryString.length() - 2);
        queryString += ' FROM ' + objectName; 
        
        if(currentPage == 1){
            queryString += ' WHERE ID >= '+ '\'' +listOfRecords[0].ID+'\''+' ORDER BY ID LIMIT '+limitSize; 
        }
        else if(currentPage > 1 && currentPage < count ){
            queryString += ' WHERE ID > '+ '\'' +listOfRecords[currentPage * limitSize - limitSize - 1].ID+'\''+' ORDER BY ID LIMIT '+limitSize;
        }
        List<SObject> queriedRecords = Database.query(queryString);
        return queriedRecords;
	}
}