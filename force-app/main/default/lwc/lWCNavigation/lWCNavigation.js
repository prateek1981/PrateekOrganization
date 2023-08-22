import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigationExampleLWC extends NavigationMixin(LightningElement) {       
    @api recordId;
    navigateToViewAccountPage() {
        
        this.NavigationMixin.Navigate({
            type: 'standard__recordPage',
            attributes: {
                recordId: '0012w00001RGjHGAA1',
                objectApiName: 'Account',
                actionName: 'view'
            },
        });
    }
    navigateToContactHome() {
        this[NavigationMixin.Navigate]({
            "type": "standard__objectPage",
            "attributes": {
                "objectApiName": "Contact",
                "actionName": "home"
            }
        });
    }
}