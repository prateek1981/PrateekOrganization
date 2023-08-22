import { LightningElement, track, wire} from 'lwc';

import getUrl from '@salesforce/apex/BoxController.getUrl';
import getAccess from '@salesforce/apex/BoxController.getAccess';
import fetchDriveFiles from '@salesforce/apex/BoxController.fetchDriveFiles';
import createTheFolder from '@salesforce/apex/BoxController.createTheFolder';
import getAccessTokenFromRefreshToken from '@salesforce/apex/BoxController.getAccessTokenFromRefreshToken';
import deleteFileOrFolder from '@salesforce/apex/BoxController.deleteFileOrFolder';
import uploadFileToBox from '@salesforce/apex/BoxController.uploadFileToBox';
import downloadFileApex from '@salesforce/apex/BoxController.downloadFile';
import checkUser from '@salesforce/apex/BoxController.checkUser';
import deleteFolder from '@salesforce/apex/BoxController.deleteFolder';
import getSubFolders from '@salesforce/apex/BoxController.getSubFolders';
export default class Box extends LightningElement {
    @track authUrl;
    @track authCode;
    @track acToken;
    @track fileData;
    @track refreshToken;
    @track showData=true;
    @track check=true;
    acceptedFormats = ['.jpg', '.jpeg', '.png', '.txt'];
    @track breadCrumbsData=[ {key : '*2910' , value : 'nill'}];
    @track breadcrumbs=['Home'];
    @track parentid='0';
    @wire (checkUser)

    checkUserExistence({data,error}) {
        console.log('Inside checkUserExistence method');
        if(data) {
            console.log('Entered in if data condition');
            if(data==='True'){
                console.log('Entered in true condition');
                fetchDriveFiles({accessToken : this.acToken})
                .then(result =>{
                    this.fileData=result;
                    this.fileData.forEach(file => {
                    if (file.type === 'folder') {
                    file.isFolder=true;
                    } else {
                        file.isFolder=false;
                    }
                });
                console.log('Value of fileData is '+JSON.stringify(this.fileData));
                
                })
                .catch(error =>{
                console.log('We are getting error in access token');
                });
            }
            else{
                console.log('Entered in false condition');
                const aUrl = window.location.search;
                console.log('Auth URL is ' + aUrl);
                const urlParams = new URLSearchParams(aUrl);
                this.authCode = urlParams.get('code');
                console.log('Auth code is '+this.authCode);
                if(urlParams.has('code')){
                    getAccess({addrs : this.authCode})
                    .then(result =>{
                        console.log('Inside get Access method');
                        this.acToken=result.access_token;
                        this.refreshToken=result.refresh_token;
                        console.log('Access token is '+this.acToken+' and refresh token is '+this.refreshToken);
                    })
                    .catch(error =>{
                      console.log('We are getting error in access token');
                    });
                    setTimeout(() => {
                        fetchDriveFiles({accessToken : this.acToken})
                        .then(result =>{
                                this.fileData=result;
                                this.fileData.forEach(file => {
                                if (file.type === 'folder') {
                                file.isFolder=true;
                                } else {
                                    file.isFolder=false;
                                }
                        });
                             console.log('Value of fileData is '+JSON.stringify(this.fileData));
                        })
                        .catch(error =>{
                             console.log('We are getting error in get files method');
                        });
                    }, 1000);
                }
                else{console.log('Entered in else get url method condition');
                    getUrl()
                    .then(result =>{
                        console.log('Get url method is called')
                        console.log('The url we are getting is '+result);
                        this.authUrl=result;
                        window.open(this.authUrl,'_self');
                    })
                    .catch(error =>{
                        console.log('We are getting an error');
                    });
                }
            }
        }
        else if(error){
            console.error('There is an error in user existence method which is '+JSON.stringify(error));
        }
    }
    handleBreadCrumbs (event){
        console.log('Hanle Bread crumbs method is called');
        var id , name;
        var check = 0;
        var folderClicked = event.currentTarget.dataset.folderclicked;
        console.log(' folder clicked : '+folderClicked);
        console.log('Id of the folder is '+id);
        var objList = this.breadCrumbsData;
        objList.forEach(element => {
            if(element.value === folderClicked){
                check = -1;
                name = folderClicked;
                id = element.key;
            }
        });
        
       if(check == -1){
            var bdcrumbs = this.breadcrumbs;
            var clickedIndex = bdcrumbs.indexOf(name);
            if(clickedIndex != -1){
                bdcrumbs.splice(clickedIndex + 1);
            }
            //console.log('i am clicked index after : '+clickedIndex);
           this.breadcrumbs=bdcrumbs;
            if(name === 'Home'){
                fetchDriveFiles({accessToken : this.acToken})
                .then(result =>{
                    this.fileData=result;
                    this.fileData.forEach(file => {
                    if (file.type === 'folder') {
                    file.isFolder=true;
                    } else {
                        file.isFolder=false;
                    }
                });
                console.log('Value of fileData is '+JSON.stringify(this.fileData));
                
                })
                .catch(error =>{
                console.log('We are getting error in access token');
                });
            }
            else{
                getSubFolders({folder : id})
                .then(result =>{
                    console.log('REsult in subfolder is '+result);
                    this.showData=false;
                    this.fileData=result;
                    this.fileData.forEach(file => {
                        if (file.type === 'folder') {
                        file.isFolder=true;
                        } else {
                            file.isFolder=false;
                        }
                    });
                    this.showData=true;
                })
                .catch(error =>{
                    console.log('Error while fetching subfolders');
                });
                }
            }
        else{
            var bdcrumbs = this.breadcrumbs;
            var clickedIndex = bdcrumbs.indexOf(folderClicked);
            if(clickedIndex != -1){
                bdcrumbs.splice(clickedIndex + 1);
            }
            this.breadcrumbs=bdcrumbs;
            fetchDriveFiles({accessToken : this.acToken})
                .then(result =>{
                    this.fileData=result;
                    this.fileData.forEach(file => {
                    if (file.type === 'folder') {
                    file.isFolder=true;
                    } else {
                        file.isFolder=false;
                    }
                });
                console.log('Value of fileData is '+JSON.stringify(this.fileData));
                
                })
                .catch(error =>{
                console.log('We are getting error in access token');
                });
       }  
    }
    fillBreadcrumb(event){
       console.log('fill breadcrumbs method is called');
        var folderid=event.target.dataset.folderid;
        var foldername=event.target.dataset.foldername;
        var foldertype=event.target.dataset.foldertype;
        this.parentid=folderid;
        console.log('Folder name is '+foldername);
        console.log('Folder id is '+folderid);
        console.log('folder type is '+foldertype);
        this.breadCrumbsData.push({key : '2910' ,value : 'nill'});
        this.breadcrumbs.push(foldername);
        this.breadCrumbsData.push({ key : folderid ,value : foldername});
        if(foldertype=== 'folder'){
            console.log('entered in folder condition ');
            getSubFolders({folder : folderid})
                .then(result =>{
                    console.log('REsult in subfolder is '+result);
                    this.showData=false;
                    this.fileData=result;
                   
                    this.showData=true;
                    this.fileData.forEach(file => {
                        if (file.type === 'folder') {
                        file.isFolder=true;
                        } else {
                            file.isFolder=false;
                        }
                    });
                })
                .catch(error =>{
                    console.log('Error while fetching subfolders');
                });
        }
       
    }
    getAuthUrl(event){
        getUrl()
            .then(result =>{
                console.log('The url we are getting is '+result);
                this.authUrl=result;
                window.open(this.authUrl,'_self');
            })
            .catch(error =>{
                console.log('We are getting an error');
            });
        
    }
    getAuthCode(event) {
        try {
            const aUrl = window.location.search;
            console.log('Auth URL is ' + aUrl);
            const urlParams = new URLSearchParams(aUrl);
            const code = urlParams.get('code');
            
            if (code) {
                this.authCode = code;
                console.log('Auth code is ' +urlParams.get('code') );
            } else {
                console.log('Auth code not found in the URL');
            }
        } catch (error) {
            console.error('Error occurred while fetching auth code:', error);
        }
    }
    getAccessToken(event){
        console.log('Auth code is '+this.authCode);
        console.log('getAccessToken method is called');
        getAccess({addrs : this.authCode})
            .then(result =>{
              this.acToken=result.access_token;
              this.refreshToken=result.refresh_token;
              console.log('Access token is '+this.acToken+' and refresh token is '+this.refreshToken);
            })
            .catch(error =>{
              console.log('We are getting error in access token');
            });
    }
    getFiles(event){
        console.log('getFiles method is called');
        console.log('The value of acToken is '+ this.acToken);
        fetchDriveFiles({accessToken : this.acToken})
            .then(result =>{
               this.fileData=result;
               this.fileData.forEach(file => {
                if (file.type === 'folder') {
                  this.isFolder=true;
                } else {
                    this.isFolder=false;
                }
            });
               console.log('Value of fileData is '+JSON.stringify(this.fileData));
               
            })
            .catch(error =>{
              console.log('We are getting error in access token');
            });
    }
    
    createFolder(event) {
        const fname = prompt('Enter folder name:');
        console.log('The name of the folder is ' + fname);
    
        if (fname) {
            this.showData = false;
            createTheFolder({ folderName: fname, accessToken: this.acToken, parentFolder: this.parentid })
                .then(result => {
                    console.log(result);
                    return fetchDriveFiles({ accessToken: this.acToken });
                })
                .then(result => {
                    this.fileData = result;
                    this.fileData.forEach(file => {
                        if (file.type === 'folder') {
                        file.isFolder=true;
                        } else {
                            file.isFolder=false;
                        }
                    });
                    this.breadcrumbs.splice(1);
                    this.showData = true;
                })
                .catch(error => {
                    console.log('Error in creating folder');
                });
        }
    }
    
    refreshAccess(event){
        console.log('Refresh access is calledd');
        getAccessTokenFromRefreshToken({refreshToken : this.refreshToken})
                    .then(result => {
                        console.log('Access token from refresh token '+result);
                        this.acToken=result;
                    })
                    .catch(error => {
                        console.log('Successfully created');
                    });
            }
    deleteFile(event){
        console.log('Delete file is calledd');
        var fid=event.target.dataset.fid;
        var ftype=event.target.dataset.ftype;
        console.log('Id of the file is '+fid);
        if(ftype=== 'folder'){
            deleteFolder({folderId: fid, accessToken: this.acToken})
            .then(result => {
                console.log(result);
                return fetchDriveFiles({ accessToken: this.acToken });
             })
             .then(result => {
                 this.fileData = result;
                 this.fileData.forEach(file => {
                    if (file.type === 'folder') {
                    file.isFolder=true;
                    } else {
                        file.isFolder=false;
                    }
                });
                 this.breadcrumbs.splice(1);
                 this.showData = true;
             })
             .catch(error => {
                 console.log('Couldnot delete');
             });
        }
        else{
            deleteFileOrFolder({ fileId: fid, accessToken: this.acToken})
            .then(result => {
               console.log(result);
               return fetchDriveFiles({ accessToken: this.acToken });
            })
            .then(result => {
                this.fileData = result;
                this.fileData.forEach(file => {
                    if (file.type === 'folder') {
                    file.isFolder=true;
                    } else {
                        file.isFolder=false;
                    }
                });
               
                this.showData = true;
            })
            .catch(error => {
                console.log('Couldnot delete');
            });
        }
            }
        handleUploadFinished(event) {
            console.log('handleUploadFinished called');
            const uploadedFiles = event.detail.files;
            for (let i = 0; i < uploadedFiles.length; i++) {
                const file = uploadedFiles[i];
                uploadFileToBox({ fileName: file.name, fileCon: file.documentId, parentID: this.parentid, accessToken: this.acToken })
                    .then(() => { 
                        console.log('File uploaded successfully');
                        return fetchDriveFiles({ accessToken: this.acToken });
                    })
                    .then(result => {
                        this.fileData = result;
                        this.fileData.forEach(file => {
                            if (file.type === 'folder') {
                            file.isFolder=true;
                            } else {
                                file.isFolder=false;
                            }
                        });
                        this.breadcrumbs.splice(1);
                        this.showData = true;
                    })
                    .catch(error => {
                        console.error('Error uploading file:', error);
                    });
            }
        }   
        downloadFile(event) {
            console.log('Hello from download :');
            const key = event.currentTarget.dataset.item;
            console.log('key : ' + key);
            downloadFileApex({
                fileId: key
            })
            .then(result => {
                console.log('result : ' + result);
                const downloadLink = document.createElement('a');
                downloadLink.href = result;
                downloadLink.download = 'file_name.ext';
                downloadLink.click();
                this.spinner = false;
            })
            .catch(error => {
                this.error = error;
                console.log('error :' + error);
            })
        }

         
}