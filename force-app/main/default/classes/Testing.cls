public class Testing {
   @AuraEnabled public Static List<String> inputObjects(){
        Map<String,Schema.SObjectType> AllData ;					//Storing every Sobject from our Org.
        List<String> ObjNames=new List<String>() ;					//Storing the Labels of the Object names used as select option
  		
        AllData=Schema.getGlobalDescribe();
       // ObjNames=new List<Selectoption>();
        for(String description:AllData.keySet()){
            Schema.DescribeSObjectResult describeobj=AllData.get(description).getDescribe();
            if(describeobj.isCustom()){
                ObjNames.add(describeobj.getLabel());
            }
        }
        return ObjNames;
    }
}