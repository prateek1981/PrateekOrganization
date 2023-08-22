import { LightningElement, api, wire } from 'lwc';

export default class Ldcchild extends LightningElement {
    @api recordId;
    @api objectApiName;
   

    currentTimePlus2Hours = '';
    connectedCallback() {
        var currentDateTime = new Date();
        console.log('UTC Time is '+currentDateTime);
        var newDateTime = new Date(currentDateTime.getTime() + (14 * 60 * 60 * 1000)); 
        var temp30mins = new Date(newDateTime.getTime() + (30 * 60 * 1000)); 

        this.currentTimePlus2Hours = temp30mins.toISOString();
        console.log('Current date and time is ' + currentDateTime.toISOString());
    }

    submitRecord() {
        this.template.querySelector('lightning-record-edit-form').submit();
    }
}
