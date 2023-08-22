import { LightningElement, api } from 'lwc';
import accName from '@salesforce/schema/Account.Name';
import accRating from '@salesforce/schema/Account.Rating';
import accDummyDate from '@salesforce/schema/Account.Dummy_Date__c';
import accDummyPicklist from '@salesforce/schema/Account.Dummy_PickList__c';

export default class LightningDataServiceComponent extends LightningElement {
    @api recordId;
    @api objectApiName;
    fields = [accName, accRating, accDummyDate, accDummyPicklist];
    objectName;

    connectedCallback() {
        this.objectName = this.objectApiName;
    }
}
