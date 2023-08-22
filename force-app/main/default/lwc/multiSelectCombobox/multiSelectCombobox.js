import { LightningElement ,track} from 'lwc';

export default class MultiSelectCombobox extends LightningElement {
    showToggle=true;
    @track isChecked=false;
    @track selectedValue='';
    @track selectedValues='';
    options = [
        {'label':'India','value':'India'},
        {'label':'USA','value':'USA'},
        {'label':'China','value':'China'},
        {'label':'Rusia','value':'Rusia'}
    ];
    handleToggle(event){

        this.isChecked=event.target.checked;
    }
    handleSelectOption(event){
        console.log('Value in handleSelectOption is '+event.detail);
        this.selectedValue = event.detail;
    }
    handleSelectOptionList(event){
        console.log(event.detail);
        this.selectedValues = event.detail;
        console.log(this.selectedValues);
    }
}