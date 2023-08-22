import { LightningElement, api } from 'lwc';
import accName from '@salesforce/schema/Account.Name';
export default class CreateRecordUsingLDS extends LightningElement {
    @api objectApiName;
    @api recordId;
    objectName;
    connectedCallback(){
        this.objectName=this.objectApiName;
    }
    submitRecord(){
        this.template.querySelector('lightning-record-edit-form').submit();
    }
}