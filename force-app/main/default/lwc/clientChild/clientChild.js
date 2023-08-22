import { LightningElement, api, track } from 'lwc';

export default class ClientChild extends LightningElement {
    @api row;
    @api column;

    @track displayData;

    connectedCallback() {
        this.displayData   = this.row[this.column];
        
    }
}