import { LightningElement,api,track } from 'lwc';

export default class Buttons extends LightningElement {
   @track totalRecords;
   @track visibleRecords;
   @track recordSize=5;
   @track totalPages;
   @track currentPage=1;
   @track totalRecordsSize;
    get records(){
        return this.visibleRecords;
    }
    @api 
    set records(data){
        if(data){
            this.totalRecords=data;
            this.totalRecordsSize=data.length;
            this.recordsUpdate();
        }
    }

    

    get checkNext(){
        return this.currentPage>=this.totalPages;
    }
    get checkPrevious(){
        return this.currentPage<=1;
    }

    recordsUpdate(){
       
        this.totalPages=Math.ceil(this.totalRecordsSize/this.recordSize);
        var start=(this.currentPage-1)*this.recordSize;
        var end=this.currentPage*this.recordSize;
        this.visibleRecords=this.totalRecords.slice(start,end);
        console.log('Visible records in button component '+JSON.stringify(this.visibleRecords));
        this.dispatchEvent(new CustomEvent('update',{
            detail:{
                records:this.visibleRecords
            }
        }))
    }
    handleNext(event){
        if(this.currentPage< this.totalPages){
            this.currentPage=this.currentPage+1;
            this.recordsUpdate();
        }
    }
    handlePrevious(event){
        if(this.currentPage>1){
            this.currentPage=this.currentPage-1;
            this.recordsUpdate();
        }
    }
    changeRecordSize(event){
        var recSize=event.target.value;
        if(recSize==='5'){
            this.recordSize=5;
        }
        if(recSize=== '10'){
            this.recordSize=10
        }
        if(recSize=== '20'){
            this.recordSize=20;
        }
        this.recordsUpdate();
    }
    handleFirst(event){
        this.currentPage=1;
        this.recordsUpdate();
    }
    handleLast(event){
        this.currentPage=this.totalPages;
        this.recordsUpdate();
    }
}