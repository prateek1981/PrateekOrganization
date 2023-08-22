import { LightningElement,track } from 'lwc';
import payByEcheck from '@salesforce/apex/PaymentGatewayController.payByEcheck';

export default class EcheckPayment extends LightningElement {
    @track routingNumber;
    @track accountName;
    @track accountNumber;
    handleChange(event) {
        console.log('handle change is called');
        if(event.target.name == 'routingnumber'){
            this.routingNumber = event.target.value;
            console.log('Rounting number is '+this.routingNumber);
        } else if(event.target.name == 'accountnumber'){
            this.accountNumber = event.target.value;
            console.log('Account Number is '+this.accountNumber);
        } else if(event.target.name == 'accountname'){
            this.accountName = event.target.value;
            console.log('Account name is '+this.accountName);
        } 
    }
    handlePayment(event){
        console.log('Handle Payment is running');
    }
}