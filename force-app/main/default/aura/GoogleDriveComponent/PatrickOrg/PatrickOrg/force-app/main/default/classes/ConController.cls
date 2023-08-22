public class ConController {
        public String objValue								{get;set;} // Stores object passed from parent class
        public List<SelectOption> fvalue 					{get;set;} // Stores fields passed from parent class
        public List<String> fieldList						{get;set;} // List of API names of fvalue
        public Integer resultSize{get;set;}
        public List<Selectoption> setRecordPerPage		    {get;set;} // Sets the page size from the drop down
        public String query									{get;set;} // Contains query to get records
        public String queryBack                             {get;set;} // Contains the modified querry when using Dictionery method

        public List<WrapperClass> listWrapper               {get;set;} // List of wrapperclass type variables 
        public List<WrapperClass> SelectedRecord            {get;set;}   // Contains record select by the user chekbox
        public List<Selectoption> selectOpt 				{get;set;} // Contains list of selected fields
        public List<String> listLabel						{get;set;} // Contains label of selected fields
        public List<sobject> records					    {get;set;} // Contains records of the object
        public List<String> Dictionery                      {get;set;} // List containing all the alphabets
        public string selectedDisc                          {get;set;} // Gets value of selected alphabet by user
        public String sortField                             {get;set;} // Contains the label of a particular field selected by the user to sort
        public Boolean tempBool;                                       // Used to sort column ascending and descending
        public String csvString                             {get;set;} // String with field names and thier values for selected records

        public ApexPages.StandardSetController setCon       {set;get;}
        public Integer size{set;get;}
    	public Set<Id> idOfselectedRecord                   {set;get;}
        public String recordId                              {set;get;} 
        public Integer pageNumber                           {get;set;}
        public Boolean tabhide                              {get;set;}
        public String sortOder                              {get;set;}
    
    public ConController(){                      
        size=5;
        pageNumber = 1;
        idOfselectedRecord =new Set<Id>();
        Dictionery = new List<String>{'A',' ','B',' ','C',' ','D',' ','E',' ','F',' ','G',' ','H',' ','I',' ','J',' ','K',' ','L',' ','M',' ','N',' ','O',' ','P',' ','Q',' ','R',' ','S',' ','T',' ','U',' ','V',' ','W',' ','X',' ','Y',' ','Z',' ','All',' ','Other'};
        sortField = '';
        sortOder = '';
        tempBool = false;
        selectOpt =  new List<SelectOption>();
        listLabel = new List <String>();
        setRecordPerPage = new List<SelectOption>();
        setRecordPerPage.add(new SelectOption('5','5'));
        setRecordPerPage.add(new SelectOption('10','10'));
        setRecordPerPage.add(new SelectOption('50','50'));
        setRecordPerPage.add(new SelectOption('100','100'));
        fvalue=new List<SelectOption>();
        records = new List<sobject>();
        fieldList = new List<String>();
       // labelList = new List<String>();
        SelectedRecord = new List<WrapperClass>();
         tabhide=true;

    }
    public void showRecord(){
         tabhide=true;
          size=5;

        query=null;
        selectOpt.clear();
        fieldList.clear();
       // System.debug('Record');
       // System.debug(fvalue);
       // System.debug(objValue);
        for(SelectOption s : fvalue){
            fieldList.add(s.getValue());
            selectOpt.add(s);
            listlabel.add(s.getLabel());
        }
        query ='Select ';
        for(String s : fieldList){
            query+= s+',';
        }
        query = query.removeEnd(',');
        query +=' From '+objValue;
       // System.debug(query);
        records = Database.query(query);
       // system.debug( ' my record '+records);
        setCon = new ApexPages.StandardSetController(records);
        setCon.setPageSize(5);
        resultSize = setCon.getResultSize();  // getResultSize = Returns the number of records in the setCon // Return Value ==Integer
        listWrapper = new List<WrapperClass>();
        for(sObject so: setCon.getRecords()){    //getrecords =Returns the list of sObjects in the current page setCon//Return=sObject[]
            listWrapper.add(new WrapperClass(so,false));
        }
        
            
        
        
    }
    public class WrapperClass{
        public sObject wObj{set;get;}
        public boolean selectedCheck{set;get;}
        public WrapperClass(sObject wObj,boolean selectedCheck){
            this.wObj=wObj;
            this.selectedCheck=selectedCheck;
        }
    }
    public void selCheckbox(){
        for(WrapperClass s : listWrapper){
            if(s.selectedCheck==true){
                selectedRecord.add(s);
                idOfselectedRecord.add(s.wObj.ID);
            }
            else if(idOfselectedRecord.contains(s.wObj.Id)&& s.selectedCheck==false){
                idOfselectedRecord.remove(s.wObj.Id);             
            }
        }
    }
    public void recordPerPage(){
        selCheckbox();
        setCon.setPageSize(size);
        records=setCon.getRecords();
        listwrapper.clear();
        for(sObject s:records){
            if(idOfselectedRecord.contains(s.Id)){
            	listWrapper.add(new WrapperClass(s,true));
            }else{
                listWrapper.add(new WrapperClass(s,false));
            }
        }       
    }    
    public void deleteLink(){
        try{
        	Database.delete(recordId); 
        }
        catch(DmlException e){
            apexPages.addMessage(new apexPages.Message(apexpages.Severity.WARNING,e.getMessage()));
        }
        showRecord();
    }
   
    public PageReference createNewRcord(){                                    //This method creates the new record of the selected object 
        String NewRecord = Schema.getglobalDescribe().get(objvalue).getDescribe().getKeyPrefix();
        //System.debug('getglobalDescribe ---'+Schema.getglobalDescribe());
        //System.debug('getKeyPrefix-----' +NewRecord);
        //System.debug('getKeyPrefix  2 -----' +Schema.getglobalDescribe().get(objvalue));  // Retern the object API Name
        return new PageReference('/' + NewRecord +'/e');      
    }
    public void firstPage(){                   //  This method takes user to first page of total records
        setCon.first();
        pageNumber = 1;
        selCheckbox();
        records = setCon.getRecords();
        listWrapper.clear();
        for(SObject sobj : records){
            if(idOfselectedRecord.contains(sobj.Id)){
               listWrapper.add(new WrapperClass(sobj,true)); 
            }else{
                listWrapper.add(new WrapperClass(sobj,false));
            }
        }
    }
   
    public void nextPage(){                // This method takes user to next page of total records
        setCon.next();
        pageNumber++;
        selCheckbox();
        records = setCon.getrecords();
        listWrapper.clear();
        for(SObject sobj : records){
            if(idOfselectedRecord.contains(sobj.Id)){
                listWrapper.add(new WrapperClass(sobj,true));    
            }
            else{
                listWrapper.add(new WrapperClass(sobj,false));
            }
        }   
    }
    public void previousPage(){                //  This method takes user to previous page of total records
        setCon.previous();
        pageNumber--;
        selCheckbox();
        records = setCon.getrecords();
        listWrapper.clear();
        for(SObject sobj : records){
            if(idOfselectedRecord.contains(sobj.Id)){
                listWrapper.add(new WrapperClass(sobj,true));
            }
            else{
                listWrapper.add(new WrapperClass(sobj,false));
            }
        }
        
    }
    public void lastPage(){                      //    This method takes user to last page of total records
        setCon.last();
        if(math.mod(setCon.getResultSize() / setCon.getPageSize(),2)==0){
            pageNumber=setCon.getResultSize() / setCon.getPageSize();
            
        }
        else{
            pageNumber=(setCon.getResultSize() / setCon.getPageSize())+1;
            
        }
        selCheckbox();
        records = setCon.getrecords();
        listWrapper.clear();
        for(SObject sobj : records){
            if(idOfselectedRecord.contains(sobj.Id)){
                listWrapper.add(new WrapperClass(sobj,true));    
            }
            else{
                listWrapper.add(new WrapperClass(sobj,false));
            }
        }
        
    }
    public void changePage(){
         selCheckbox();
         pageNumber=pageNumber;
          
        records = setCon.getrecords();
        listWrapper.clear();
        for(SObject sobj : records){
            if(idOfselectedRecord.contains(sobj.Id)){
                listWrapper.add(new WrapperClass(sobj,true));
            }
            else{
                listWrapper.add(new WrapperClass(sobj,false));
            }
        }
        
    }
    public void deleteRecord(){
        selCheckbox();
        List<sObject> delrecord = new List<sObject>();
        for(WrapperClass w : selectedRecord){
            delrecord.add(w.wObj);
        }
        try{
            delete(delrecord);
        }
        catch(DmlException e){
          apexPages.addMessage(new ApexPages.message(apexpages.Severity.WARNING,e.getMessage()));  
        }
        showRecord();
    }
     public void DictioneryMethod(){
        tabHide=true;
        String temp='A';
        if(objValue=='Case'){
            if(selecteddisc == 'all'){    
                queryBack=query;
                if(setCon.getRecords() == null){
                apexPages.addMessage(new apexPages.Message(apexpages.Severity.WARNING,'No Records'));
           	    }
                else{
                  setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryBack));
                }
               // System.debug(queryBack); 
            }
            else{
                queryBack = query + ' WHERE caseNumber LIKE\''+selecteddisc+'%\'';
                if(setCon.getRecords() == null){
                apexPages.addMessage(new apexPages.Message(apexpages.Severity.WARNING,'No Records'));
              }
                else{
                  setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryBack)); 
                }
              //  System.debug(queryBack);
            }
            
        }
        else {
            if(selecteddisc == 'all'){    
                queryBack=query;
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryBack));
               // System.debug(queryBack); 
            }
            else if(selecteddisc == 'other'){
                queryBack=query + ' WHERE Name <:temp ';
               // System.debug(queryBack);
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryBack));
            }
            else{
                queryBack = query + ' WHERE name LIKE\''+selecteddisc+'%\'';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryBack));   
               // System.debug(queryBack);
            }
            
        }
        selCheckBox();
        setCon.setPageSize(size);
        records = setCon.getrecords();
        listWrapper.clear();
        for(SObject sobj : records){
            if(idOfselectedRecord.contains(sobj.Id)){
                listWrapper.add(new WrapperClass(sobj,true));    
            }
            else{
                listWrapper.add(new WrapperClass(sobj,false));
            }
        }   
        if(records.size()==0){
            apexPages.addMessage(new apexPages.Message(apexpages.Severity.WARNING,'No Records'));
            tabhide = false;
        }   
    }
  
    public void colSorting(){                           //   This method sort data in Ascending and descending order
       // System.debug(sortField);
        String tempStr;
        if(tempBool == false){
            sortOder = 'ASC';
            tempStr = query+' ORDER BY '+sortField+' '+ sortOder+' NULLS LAST';
            tempBool = true;
          //  System.debug(tempStr);
        }
        else{
            sortOder = 'DESC';
            tempStr = query+' ORDER BY '+sortField+' '+sortOder+'  NULLS LAST';
            tempBool = false;
           // System.debug(tempStr);
        }
        selCheckBox();
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(tempStr));
        setCon.setPageSize(Size);
        listWrapper.clear();
         for(SObject sobj :Database.query(tempStr) ){
            if(idOfselectedRecord.contains(sobj.Id)){
                listWrapper.add(new WrapperClass(sobj,true));    
            }
            else{
                listWrapper.add(new WrapperClass(sobj,false));
            }
        }   
        recordPerPage();
        
    }

    public void downloadCsv(){                    // This method creates the string of field names with thier values
        System.debug('ENtered into downloadCsv');
        selCheckBox();
        String tempString = query+' WHERE Id IN : idOfselectedRecord';
        List<sObject> tempList = new List<sObject>();
        tempList = database.query(tempString);
        csvString = String.join(listLabel,',')+ '\\n';  //terableObj, separator
        //listWrapper.clear();
        //listWrapper = [SELECT ];
        for(sObject sobj : tempList){           
                //sObject sob = sobj.wrapObj;
                for(Integer i=0;i<fieldList.size();i++){
                    csvString += sobj.get(fieldList[i])+',';                    
                }
                csvString = csvString + '\\n';
                
            }
        
        System.debug(csvString);
    }

}