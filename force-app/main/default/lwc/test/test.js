import { LightningElement,track,wire } from 'lwc';
import fetchObject from '@salesforce/apex/Client_Side_Pagination_Controller.fetchObject';
export default class Test extends LightningElement {
    @track selectedObject='';
    @track objectOptions= [];
    
    @wire (fetchObject)
    getObjectResult({ data, error }) {
       if (data) {
           console.log('Data is'+data);
           this.objectOptions = data.map(obj => ({
               label: obj.objectLabel,
               value: obj.objectName
           }));
           console.log('Data in selectlist is'+JSON.stringify(this.objectOptions));
           }
       else if (error) {
           console.error('Error retrieving object metadata', error);
       }
    }
}