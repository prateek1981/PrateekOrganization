public class MjorAssignment1 {    
        public Map<String,Schema.SObjectType> objListMap	{get;set;} 
        List<String> standarobjectList = new List<String>();
                  
        public List<String> objList				{get;set;}    // Stroes all sobjects names
        public List<Selectoption> objNames		{get;set;}    // Contains objects with there label and API name
        public List<SelectOption> fldList		{get;set;}    // Contains Fields of the selected object with there label and name
        public List<Selectoption>addedfldlist	{get;set;}    // Contains label of the fields selected by the user 
        public String SelectedObject			{get;set;}    // Stores objects selected by the user
        public List<String> selectedfield		{get;set;}    // Stores fields selected by the user
        public List<String> removeSelectedFields{get;set;}    // Remove the fields selected by the user from addfldlist
        public boolean disableAdd 				{get;set;}    //  add button Able/disable
        public boolean disableRemove 			{get;set;}    //  Remove button Able/disable
        public Boolean disableByPanelGride	    {get;set;}    //  panelGrid rendered
        public Boolean hideComponent			{get;set;}
        public boolean ResetButton              {set;get;}
        
        Map<String,Schema.SObjectField> fieldMap = new Map<String,Schema.SObjectField>(); // Creating a map with field name as key and field as value 
        
        public MjorAssignment1() {                    // Constructor method that initializes the properties of the class
            String standarobjects ;
            objListMap = Schema.getGlobalDescribe();   
            objList = new List<String>(objListMap.keySet());
            standarobjects = system.Label.StandardObjectsCustomLabels;
    
            standarobjectList = standarobjects.split(',');
            objNames = new List<SelectOption>();
            ResetButton = true;
            disableAdd = true;               
            disableRemove=true;
            hideComponent=false;
            selectedfield = new List<String>();
            addedfldlist = new List<Selectoption>();
            objNames.add(new SelectOption('--None--','--None--'));
            for(String obj : objList){
                Schema.DescribeSobjectResult describedObj = objListMap.get(obj).getDescribe();   //DescribeSObjectResult Class-->Contains methods for describing SObjects
                
                if(describedObj.isCustom() || standarobjectList.contains(describedObj.getName())){	
                    objNames.add(new SelectOption(describedObj.getName(), describedObj.getLabel())); 
                }
            }
            objNames.sort();
        }    
        public void fieldList() {               
            if(SelectedObject !='--None--') {
              
                disableByPanelGride = true;
               // disableADD = false;
                ResetButton = false;          
                fldList = new List<SelectOption>();
                         
                fieldMap = objListMap.get(SelectedObject).getDescribe().fields.getMap();
                
                for(Schema.SObjectField fieldname : fieldMap.values()){
                    
                    Schema.DescribeFieldResult fieldResult = fieldname.getDescribe();
                    if(fieldResult.isAccessible() && fieldResult.isUpdateable() && fieldResult.isCreateable() ){
                        fldlist.add(new Selectoption(fieldResult.getName(),fieldResult.getLabel()));
                    }             
                     fldlist.sort();
                }
                fldlist.sort();
                if(addedFldList != null){
                    addedfldList.clear();
                }
                disableRemove = true; 
                
            }
            if(Selectedobject=='--None--'){
                disableByPanelGride=false;
                ResetButton = true;
            }
            hideComponent=false;
            disableAdd = false;
             
        } 
       
      
        
        public void add(){           
               
            for(String s : selectedfield ){
                    // disableAdd = false;
               
                    if(fldList.size()==0){
                        disableAdd = true;
                    }
                    fldList.remove(fldList.indexOf(new selectOption(s,fieldMap.get(s).getDescribe().getLabel())));
                    addedfldlist.add(new selectoption(s,fieldMap.get(s).getDescribe().getLabel()));
    
                    if(fldList.size()==0){
                        disableAdd=true;
                    }
                     
                    hideComponent=false;               
                }     
                disableRemove = (addedfldList.size()>0)?false:true;
                addedfldlist.sort();
                fldList.sort();
        }    
        public void remove(){                       // Method that removes the selected fields from the added fields list
            for(String s : RemoveSelectedfields ){    
                hideComponent=false;
                addedfldList.remove(addedfldList.indexOf(new selectOption(s,fieldMap.get(s).getDescribe().getLabel())));    
                fldList.add(new selectoption(s,fieldMap.get(s).getDescribe().getLabel()));							
            }   
            addedfldList.sort();
            fldlist.sort();
            disableAdd = (fldlist.size()!=0)?false:true;
            disableRemove = (addedfldList.size()>0)?false:true;
        }    
        public void reset(){                        // Method that resets the properties of the class     
            Selectedobject = '--None--';   
            if(fldList.size()>0){
                fldList.clear();
            }       
            addedfldList.clear();
            disableADD=False;
            disableByPanelGride = false;
            hideComponent=false;
            ResetButton = true;
        }   
        public void process(){
                   disableRemove = false;
                    hideComponent=true;
        }   
    	

}