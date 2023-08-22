import { LightningElement ,track} from 'lwc';
import showAllFiles from '@salesforce/apex/SalesforceIntegrationController.showAllFiles';
import uploadFiles from '@salesforce/apex/SalesforceIntegrationController.uploadFiles';
export default class MyComponent extends LightningElement {
    @track fileData;
    showbutton=true;
    //@track iconType=false;
    connectedCallback() {
        showAllFiles()
            .then(response => {
                console.log('response '+response);
                if (response) {
                    const parsedResponse = JSON.parse(response);
                    console.log('Our data is '+parsedResponse);
                  this.fileData=parsedResponse;
                  parsedResponse.forEach(item => {
                    console.log('item1 '+JSON.stringify(item));
                    if (item.FileType === 'TEXT') {
                        console.log('entered in text');
                       item.iconType=true;
                    } else {
                        console.log('entered in else');
                        item.iconType=false;
                    }
                    console.log('item2 '+JSON.stringify(item));
            });
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }
    handleUploadFinished(event){
        console.log('upload called');
        var uploadingFiles = event.detail.files[0];

        var jsonString = JSON.stringify(uploadingFiles);
        var filetoString = btoa(jsonString);

        var filename11 = uploadingFiles.name;
        var parentId = this.folderId;
        var typeOf = uploadingFiles.mimeType;
        uploadFiles({filename: filename11, file64: filetoString})
        .then(result=>{
            alert(result);
            if(result == 'Upload Success'){
                console.log('inseide succes upload '+ filename11);
                var files = this.files;
                var item = ({
                    Title : filename11
                })
                files.push(item);
                this.files = files;
            }

        })
    }     
}
