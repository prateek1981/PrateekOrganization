import { LightningElement ,track} from 'lwc';
import payByAuthrizePayment from '@salesforce/apex/PaymentGatewayController.payByAuthrizePayment';
import payByEcheck from '@salesforce/apex/PaymentGatewayController.payByEcheck';
import PaymentImage from '@salesforce/resourceUrl/PaymentImage';
import AuthorizeNet from '@salesforce/resourceUrl/AuthorizeNet'
import Authorize from '@salesforce/resourceUrl/Authorize';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PaymentGateway extends LightningElement {
   

    firstName='Prateek';
    lastName='Shekhawat';
    @track cardNumber;
    @track cvv;
    @track cardMonth;
    @track cardYear;
    @track variant='success';
    amount=500;

    @track routingNumber;
    @track accountName;
    @track accountNumber;
    @track checkPayment=true;
    processImage=AuthorizeNet+'/Authorizenet.png';
    handleChange(event) {
        console.log('handle change is called');

        if(event.target.name == 'cardnumber'){
            this.cardNumber = event.target.value;
            console.log('Card number is '+this.cardNumber);
        } else if(event.target.name == 'month'){
            this.cardMonth = event.target.value;
            console.log('month is '+this.cardMonth);
        } else if(event.target.name == 'year'){
            this.cardYear = event.target.value;
            console.log('year is '+this.cardYear);
        } else if(event.target.name == 'cvv'){
            this.cvv = event.target.value;
            console.log('CVV is '+this.cvv);
    }
}
    handlePayment(){
        console.log(this.cardNumber);
        var mess;
        payByAuthrizePayment({firstName : this.firstName, lastName : this.lastName, cardNumber : this.cardNumber, amount : this.amount, 
                              cardMonth : this.cardMonth, cardYear : this.cardYear, cvv : this.cvv
         
        })
        .then(res=>{
           mess=res;
            console.log('Response is '+mes);
           if(mes==='Not Approved'){
            this.variant='error';
        }
        }).catch(err=>{
            console.log('Error');
        }).finally(()=>{
            const toastEvent = new ShowToastEvent({
                title:'Result',
                message: mess,
                variant: this.variant
            });
            this.dispatchEvent(toastEvent);
        })
    }
 
    checkPaymentMethod(event){
        if(this.checkPayment==true)
        this.checkPayment=false;
        else
        this.checkPayment=true;
    }
    shandleChange(event) {
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
    shandlePayment(event){
        var mess;
        console.log('Handle Payment is running');
        payByEcheck({routingNumber : this.routingNumber, accountNumber : this.accountNumber, cardName : this.accountName
        })
        .then(res=>{
            mess=res;

            if(mes==='Not Approved'){
                this.variant='error';
            }
        }).catch(err=>{
            console.log('Error');
        }).finally(()=>{
            const stoastEvent = new ShowToastEvent({
                message: mess,
                variant: this.variant
            });
            this.dispatchEvent(stoastEvent);
        })
    }
}