import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import Count_Operate from '@salesforce/messageChannel/updateCount__c';

export default class MessageSubscriber extends LightningElement {
    count = 0;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeTheMessageChannel();
    }

    subscribeTheMessageChannel() {
        const subscription = (message) => this.handleMessage(message);
        subscribe(this.messageContext, Count_Operate, subscription);
    }

    handleMessage(customMessage) {
        if (customMessage.operator === 'add') {
            this.count += customMessage.constant;
        } else if (customMessage.operator === 'subtract') {
            this.count -= customMessage.constant;
        } else if (customMessage.operator === 'multiply') {
            this.count = customMessage.constant * 2;
        }
    }
}
