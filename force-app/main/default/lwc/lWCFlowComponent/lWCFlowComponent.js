import { LightningElement, wire, api } from 'lwc';
import getContacts from '@salesforce/apex/LWCAccountContactsFlow.getContacts';

export default class LWCFlowComponent extends LightningElement {
    @api accId;
    data;
    columns = [
        { label: 'Name', fieldName: 'Name' }, // Assuming API name for Name field is 'Name'
        { label: 'Phone', fieldName: 'Phone', type: 'phone' }, // Assuming API name for Phone field is 'Phone'
        { label: 'Email', fieldName: 'Email' }, // Assuming API name for Email field is 'Email'
    ];

    // This is the wire adapter function
    @wire(getContacts, { contactId: '$accId' })
    wiredRecords({ error, data }) {
        if (data) {
            console.log('Data is '+data);
            this.data = data;
        } else if (error) {
            console.error('Error fetching records:', error);
        }
    }
}
