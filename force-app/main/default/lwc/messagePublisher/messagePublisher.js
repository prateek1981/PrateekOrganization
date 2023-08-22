import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import Count_Operate from '@salesforce/messageChannel/updateCount__c';

export default class MessagePublisher extends LightningElement {
    @wire(MessageContext)
    messageContext;

    handleAdd() {
        let dataCollection = {
            operator: 'add',
            constant: 1
        };
        publish(this.messageContext, Count_Operate, dataCollection);
    }

    handleSubtract() {
        let dataCollection = {
            operator: 'subtract',
            constant: 1
        };
        publish(this.messageContext, Count_Operate, dataCollection);
    }

    handleMultiply() {
        let dataCollection = {
            operator: 'multiply',
            constant: 2
        };
        publish(this.messageContext, Count_Operate, dataCollection);
    }
}
