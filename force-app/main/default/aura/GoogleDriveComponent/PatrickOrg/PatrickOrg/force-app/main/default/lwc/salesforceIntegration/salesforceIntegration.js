import { LightningElement ,track} from 'lwc';
import showAllFiles from '@salesforce/apex/SalesforceIntegrationController.showAllFiles';
import uploadedTheFiles from '@salesforce/apex/SalesforceIntegrationController.uploadedTheFiles';
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
            console.log('handleUploadFinished called');
            const uploadedFiles = event.detail.files;
            for (let i = 0; i < uploadedFiles.length; i++) {
                const file = uploadedFiles[i];
                console.log('Document id is '+file.documentId);
                uploadedTheFiles({ fileName: file.name, fileid: file.documentId })
                    .then(() => {
                        console.log('File uploaded successfully');
                        return showAllFiles();
                    })
                    .then(result => {
                        const parsedResponse = JSON.parse(result);
                        console.log('Our data is '+parsedResponse);
                      this.fileData=parsedResponse;
                      this.fileData.forEach(item => {
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
                    })
                    .catch(error => {
                        console.error('Error uploading file:', error);
                    });
            }
    }
            
}