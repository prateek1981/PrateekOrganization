import { LightningElement, api } from 'lwc';

export default class GetterSetterParent extends LightningElement {
    fullName='';

    @api
    get fName(){
        return this.fullName;
    }
    set fName(value){
        this.fullName=value.toUpperCase();
    }
}