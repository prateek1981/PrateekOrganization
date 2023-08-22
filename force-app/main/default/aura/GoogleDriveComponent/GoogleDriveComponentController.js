({
    userCheck : function(component, event, helper) {
        console.log('User check method is calling');
		var check=component.get("c.checkUserExist");
        
        check.setCallback(this, function(response){
           var resp=response.getReturnValue();
           console.log('respose  is  gettinng');
            if(resp === 'True'){
                console.log('Entering in true conndition');
               helper.fileData(component, event);
            }
            else{
                console.log('Entering in false conndition');
                  const queryString = window.location.search;
                    const urlParams = new URLSearchParams(queryString);
                    var code = urlParams.get('code');
                    console.log(code);
                    if(urlParams.has('code')){
                        helper.acToken(component,event,code);
                        setTimeout(() => {
                            helper.fileData(component,event);
                        }, 1000);
                    }
                    else{
                            helper.getAuthCo(component,event);
                    }
            }
        });
        $A.enqueueAction(check);
         
	},
	DriveAuthController : function(component, event, helper) {
        
		var temp=component.get("c.DriveAuth");
        var show;
        temp.setCallback(this, function(response){
           
            show= response.getReturnValue();
        
            console.log("Response are getting>>>>>>>>>>>>>>"+show);
        });
        $A.enqueueAction(temp);
         var child;
        
	},
    getAuthCode : function(component, event, helper){
    
        const urlParams = new URLSearchParams(window.location.search);
		var codeParam = urlParams.get('code');
        codeParam=codeParam.replace('/0','%2F0');
	component.set("v.addr",codeParam);
     component.set("v.check",true);   
	},
    getAccess : function(component, event, helper){
     var address=component.get("v.addr");
     var acc=component.get("c.getAccessToken");
         acc.setParams({
            addrs:address
        })
     acc.setCallback(this, function(response){
                   
            console.log("Access token is >>>>>>>>>>>>>>"+response.getReturnValue());
         component.set("v.addr",response.getReturnValue());
        });
        $A.enqueueAction(acc);
	},
            
     getFiles : function(component, event, helper){
         var getf=component.get("c.fetchDriveFiles");
		 getf.setParams({
            accessToken:component.get("v.addr")
        })
    	 getf.setCallback(this, function(response){
         var state= response.getState();
         if(state ==='SUCCESS'){
             
             
             component.set("v.dataList",response.getReturnValue());
            
         }
			});
    	
        $A.enqueueAction(getf);
	},
     getRefreshAccess : function(component, event, helper){
         var getf=component.get("c.getFromRefreshToken");
        getf.setParams({
            refresh:'1//0g4WFeElvfbOfCgYIARAAGBASNwF-L9IrmW9f_igNi0jL8qzgdeup3xF-EoIi86_-REWjX004uw0FuN8V7663YjKAPRCs93aqSXs'              
            });
     	getf.setCallback(this, function(response){
         component.set("v.addr",response.getReturnValue());
            console.log("Refresh access token is >>>>>>>>>>>>>>"+JSON.stringify(response.getReturnValue()));
        });
        $A.enqueueAction(getf);
	},
        readFile : function(component, event, helper) {
        var file = component.find("fileId").get("v.files")[0];
        var reader  = new FileReader();

        reader.onload = function() {
            var fileContent = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContent.indexOf(base64) + base64.length;

            fileContent = fileContent.substring(dataStart);
            console.log(fileContent);
            var action = component.get("c.createFile"); 

        action.setParams({
            filename: file.name,
            base64: encodeURIComponent(fileContent),
            accessToken: componnent.get("v.addr")
        });
        action.setCallback(this, function(response) {
           console.log(response.getReturnValue());
        })

        $A.enqueueAction(action);
        $A.get("e.force:closeQuickAction").fire();
        }
        reader.readAsDataURL(file); 
       
    },
    handleDownloadFile : function(component, event, helper){
    var file = event.currentTarget.dataset.rec;
     console.log('File id is'+file);
     var action=component.get("c.getFileUrl");
     action.setParams({
         fileId:file,
         accessToken:component.get("v.addr")
        });
     action.setCallback(this, function(response) {
          var webContentLink =response.getReturnValue(); 
          var a = document.createElement('a');
          a.href = webContentLink;
          a.download = 'file_name'; // Provide a desired filename
          a.click(); 
     })
     $A.enqueueAction(action);
        },
            
      createNew : function(component, event, helper){
        console.log('create new is called');
         var userInput = window.prompt('Please enter a string:');
           if (userInput !== null) {
           var create=component.get("c.createFolder");
           create.setParams({
           accessToken:component.get("v.addr"),
           filename:userInput,
           parent:component.get("v.parentFolder")
            })
            $A.enqueueAction(create);
             setTimeout(() => {
                            helper.fileData(component,event);
                        }, 1000);
      	} else {
            console.log('User canceled the input.');
          }
          component.set("v.showTable" , false);
          var action=component.get("c.fetchDriveFiles");
         action.setParams({
                 accessToken:component.get("v.addr")
          })
            action.setCallback(this, function(response) {
              
              console.log("response is getting"+ response.getReturnValue());
                component.set("v.dataList" , response.getReturnValue());
                  component.set("v.showTable" , true);
           })
          $A.enqueueAction(action);
	},
       getSubfiles : function(component, event, helper){
        var pid=event.currentTarget.dataset.parentid; 
        console.log('Id of the parent folder is'+pid);
        var getchild=component.get("c.getSubfoldersAndFiles");
        getchild.setParams({
            parentfolderid:pid,
            accessToken:component.get("v.addr")
            }) 
            $A.enqueueAction(getchild);   
	},
         handleDeleteFile : function(component, event, helper){
            var pid=event.currentTarget.dataset.delid; 
            console.log('Id of the file is'+pid);
            var del=component.get("c.deleteFileOrFolder");
            del.setParams({
                fileId:pid
            }) 
            $A.enqueueAction(del);   
             
             setTimeout(() => {
                  var fetchd=componennt.get("c.fetchDriveFiles");
                  fetchd.setCallback(this, function(response) {
                      component.set("v.dataList",response.getReturnValue());
                 })
                 $A.enqueueAction(fetchd);
             }, 2000);
             component.set("v.showTable" , false);
             var action=component.get("c.fetchDriveFiles");
            action.setParams({
                    accessToken:component.get("v.addr")
             })
               action.setCallback(this, function(response) {
                 
                 console.log("response is getting"+ response.getReturnValue());
                   component.set("v.dataList" , response.getReturnValue());
                     component.set("v.showTable" , true);
              })
             $A.enqueueAction(action);
	},
            
      
       handleUploadFinished: function(component, event, helper) {
  		var uploadedFiles = event.getParam("files");
        var docid=uploadedFiles[0].documentId;
		console.log("Name of the file is>>>>>>>"+uploadedFiles[0].name);
         var temp1=component.get("c.uploadTheFile");
         temp1.setParams({
            filename:uploadedFiles[0].name,
            parentid:component.get('v.parentFolder'),
            filecon:uploadedFiles[0].documentId,
             cd:docid,
             accessToken:component.get("v.addr")
            }) 
            $A.enqueueAction(temp1);
            component.set("v.showTable" , false);
            var action=component.get("c.fetchDriveFiles");
           action.setParams({
                   accessToken:component.get("v.addr")
            })
              action.setCallback(this, function(response) {
                
                console.log("response is getting"+ response.getReturnValue());
                  component.set("v.dataList" , response.getReturnValue());
                    component.set("v.showTable" , true);
             })
            $A.enqueueAction(action);
      },
      helperHandleFolderData : function(component , event , helper){
        var map = [];
        map.push({key : '*2910' , value : 'nill'});
        component.set("v.mapofIdName" , map);
        console.log('Map of id is'+component.get('v.mapofIdName'));
        var idFolder = event.currentTarget.dataset.folderid;
        component.set("v.parentFolder",idFolder);
        var nameFolder = event.currentTarget.dataset.foldername;
        console.log(' folder name : '+nameFolder);
        console.log('folder id : '+idFolder);
         
        var breadcrumb = component.get('v.breadcrumbs');
        var mapId = component.get('v.mapofIdName');
        
        mapId.push({ key : idFolder ,value : nameFolder});
        component.set("v.mapofIdName" , mapId);
       
        if(nameFolder != 'Home'){
            breadcrumb.push(nameFolder);
            component.set("v.breadcrumbs" , breadcrumb);
        }
          console.log('BreadCrumb is'+breadcrumb);
        var action = component.get("c.getSubfoldersAndFiles");
        action.setParams({
            parentfolderid : idFolder,
            accessToken : component.get('v.addr') //checkthis
        })
        action.setCallback(this , function(response){
            var state = response.getState();
            console.log("State is:"+state);
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.showTable" , false);
                component.set("v.dataList" , response.getReturnValue());
                component.set("v.showTable" , true);
            };
        });
        $A.enqueueAction(action);
    },
             
    handleBreadCrumbs : function(component , event , helper){
        var id , name;
        var check = 0;
        var folderClicked = event.currentTarget.dataset.folderclicked;
        console.log(' folder clicked : '+folderClicked);
        var objList = component.get('v.mapofIdName');
        for(var obj of objList){
            if(obj.value === folderClicked){
                check = -1;
                name = folderClicked;
                id = obj.key;
            }
       }
       if(check == -1){
        helper.helperHandleBreadCrumbData(component , id , name);
       }else{
            var breadcrumbs = component.get('v.breadcrumbs');
            var clickedIndex = breadcrumbs.indexOf(folderClicked);
            if(clickedIndex != -1){
                breadcrumbs.splice(clickedIndex + 1);
            }
            component.set("v.breadcrumbs" , breadcrumbs);
            console.log('i am comp br : '+component.get('v.breadcrumbs'));
            helper.fileData(component , event , helper);
       }  
    }
})