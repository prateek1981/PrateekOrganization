import { LightningElement, api } from 'lwc';

export default class LDCParentComponent extends LightningElement {
    showChild=false;
    handleOnClick(){
        this.showChild=true;
    }
}