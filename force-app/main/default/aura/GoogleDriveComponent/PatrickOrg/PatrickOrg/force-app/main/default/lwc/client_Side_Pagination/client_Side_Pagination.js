import { LightningElement, track, wire} from 'lwc';
import fetchObject from '@salesforce/apex/Client_Side_Pagination_Controller.fetchObject';
import fetchFields from '@salesforce/apex/Client_Side_Pagination_Controller.fetchFields';
import fetchRecords from '@salesforce/apex/Client_Side_Pagination_Controller.fetchRecords';
import fetchFieldsApi from '@salesforce/apex/Client_Side_Pagination_Controller.fetchFieldsApi';
export default class Client_Side_Pagination extends LightningElement {

     @track selectedObject='';
     @track objectOptions= [];
     @track fieldList=[];
     @track data=[];
     @track selectedFields=[];
     @track allRecords=[];
     @track testField=[];
     @track fieldMap = new Map();
     @track originalRecords=[];
     @track checkField=false;
     @track checkTable=false;
     @track sortedColumn='asc';
     @track childKey=1;
     @track showProcess=false;
     @track visibleData=[];
     @track allSelected=false;
     
     @wire (fetchObject)
     
     getObjectResult({ data, error }) {
        if (data) {
           
            this.objectOptions = data.map(obj => ({
                label: obj.objectLabel,
                value: obj.objectName
            }));
           
            }
        else if (error) {
            console.error('Error retrieving object metadata', error);
        }
     }

     getFields(event){
        this.checkTable=false;
        console.log('Inside getfields  method');
        var obName=event.target.value;
        this.selectedObject=obName;
        console.log('Name of the object selected is'+event.target.value);
        fetchFields({objname : obName})
        .then(result => {
            
            this.testField=result;
            this.fieldList = result.map(field => ({
                label: field.fieldLabel,
                value: field.fieldName
            }));
            this.fieldList.forEach(field => {
                this.fieldMap.set(field.label, field.value);
              });
            this.showProcess=true;
            this.checkField=true;
            console.log('fieldList=>>>>>>>'+JSON.stringify(fieldList));
        })
        .catch(error => {
            console.log('There is an error which is'+error);
        })
     }
tableMethod(event){
  this.checkTable=true;
}
getRecords(event){
  console.log('getRecords method is called');
  console.log('Selected fields are' + event.target.value);
  this.selectedFields = event.detail.value;
  console.log('selected object is' + this.selectedObject);
  var fieldSelected = event.detail.value;
 console.log(fieldSelected);
  var obj = this.selectedObject;
  console.log('fieldSelected:>>>>>' + fieldSelected);
  fetchFieldsApi({fselected:fieldSelected, objname:obj})
    .then(result => {
        this.selectedFields=result;
        console.log('Result we are getting from fetchFieldApi>>>'+this.selectedFields);
    })
    .catch(error => {
        console.log('There is an error which is'+error);
    })

  fetchRecords({ selectedObject: obj, fSelected: fieldSelected })
    .then(result => {

      result.forEach(element => {
        this.allRecords.push(element);
    });
       
    })
    .catch(error => {
      console.log('There is an error which is' + error);
    });
   
}
renderedCallback() {
  this.dispatchEvent(new CustomEvent('childrendered'));
}
handleChildRendered() {
  console.log('Is it working???');
}
updateData(event){
  this.visibleData=event.detail.records;
  console.log('Visible data in parent component '+JSON.stringify(this.visibleData));
  console.log('update records method is running');
}
sortRecords(event){
  var clickedColumn=event.target.dataset.column;
  console.log('Clicked column is '+clickedColumn);
  
  if (this.sortedColumn === clickedColumn) {
      this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
  } else {
      this.sortedColumn = clickedColumn;
      this.sortDirection = 'asc';
  }
  this.sortAll();
}
sortAll(){
  
  this.allRecords.sort((a, b) => {
    const valueA = a.records[this.sortedColumn];
    const valueB = b.records[this.sortedColumn];
    let comparison = 0;

    if (valueA > valueB) {
      comparison = 1;
    } else if (valueA < valueB) {
      comparison = -1;
    }

    return this.sortDirection === 'asc' ? comparison : -comparison;
  });

 
}
handleSelectAll(event){
  console.log('handleSelectAll method is called');
  var isChecked=event.target.checked;
  this.allSelected=isChecked;
  console.log('Value of is allSelected is'+this.allSelected);
  this.allRecords=this.allRecords.map((element) => ({
    ...element,
    checkbox: isChecked,
  }));
  console.log('the updated visibleData is'+JSON.stringify(this.visibleData));
}
handleCheckbox(event){
  console.log('Handle checkbox method is called');
  var isChecked = event.target.checked;
  var recId = event.target.dataset.rec;
  console.log('Value of rec is 1:', recId);

  this.allRecords = this.allRecords.map(rec => {
    if (rec.records.Id === recId) {
      return { ...rec, checkbox: isChecked };
    }
    else{
      return rec;
    }
    
   
  });
  const isAnyUnchecked = this.allRecords.some(rec => !rec.checkbox);
  this.allSelected = !isAnyUnchecked;
}

}