public class ChildComponentController {
	
    
    @AuraEnabled
    public static DataTableWrapper fatchData(List<String> fieldlt,String objectName, Integer pagSize,Integer pagNumber,String direction,String sortField,List<ID> selectId){
        List<SObject> recordsList=new List<SObject>();
		system.debug('Methodisruing>>>>>>>>>>>>>>');
        String totalStr='Select Id,'+String.join(fieldlt,', ')+' From '+objectName+' Order By '+sortField+' '+direction ;
        System.debug(totalStr); 
        List<SObject> allRecordList=Database.query(totalStr);
        Set<ID> checkboxList=new Set<ID>();
        Integer startLoop;
        Integer endLoop;
        startLoop=pagNumber*pagSize;
        endLoop=(pagNumber+1)*pagSize;
        if(endLoop>=allRecordList.size()){
            endLoop=allRecordList.size();
        }
        for(Integer i=startLoop;i<endLoop;i++){
            recordsList.add(allRecordList[i]);
        }
        for(Integer i=0;i<selectId.size();i++){
                checkboxList.add(selectId[i]);
        }
        System.debug('list'+checkboxList);
        DataTableWrapper datadetails=new DataTableWrapper();
        datadetails.totalRecords=allRecordList.size();
        datadetails.dataList=recordsList;
        datadetails.checkboxhandle=checkboxList;
        return datadetails;
    }


    public class DataTableWrapper {
       
        @AuraEnabled
        public Set<ID> checkboxhandle {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public List<SObject> dataList {get;set;}
    }
}