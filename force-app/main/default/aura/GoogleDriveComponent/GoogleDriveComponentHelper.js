({
	fileData : function(component, event) {
        console.log('File Data method is calling');
		 var getf=component.get("c.fetchDriveFiles");
		 getf.setParams({
            accessToken:component.get("v.addr")
        })
    	 getf.setCallback(this, function(response){
         var state= response.getState();
         if(state ==='SUCCESS'){
             console.log("Response from  fetch  files"+response.getReturnValue());
             component.set("v.dataList",response.getReturnValue());
            
         }
			});
    	
        $A.enqueueAction(getf);
	},
    
      acToken : function(component,event,code) {
         var acc=component.get("c.getAccessToken");
             acc.setParams({
                addrs:code
            })
         acc.setCallback(this, function(response){
                       
                console.log("Access token is >>>>>>>>>>>>>>"+response.getReturnValue());
             component.set("v.addr",response.getReturnValue());
            });
            $A.enqueueAction(acc);
		
	},
    
    getAuthCo : function(component,event) {
        var newtemp=component.get("c.DriveAuth");
        var show;
        newtemp.setCallback(this, function(response){
           
            show= response.getReturnValue();
        
            console.log("Response are getting>>>>>>>>>>>>>>"+show);
        });
        $A.enqueueAction(newtemp);
         var child;
        setTimeout(() => {
            child=window.open(show);
            }, 2000)
	},
    helperHandleBreadCrumbData : function(component , idFolder , nameFolder){
        console.log('.................');
        console.log('Clicked folder name  : '+nameFolder);
        var breadcrumbs = component.get('v.breadcrumbs');
        var clickedIndex = breadcrumbs.indexOf(nameFolder);
        if(clickedIndex != -1){
            breadcrumbs.splice(clickedIndex + 1);
        }
        //console.log('i am clicked index after : '+clickedIndex);
        component.set("v.breadcrumbs" , breadcrumbs);
        if(nameFolder === 'Home'){
            var action = component.get("c.fetchDriveFiles");
            action.setParams({
            accessToken : component.get('v.addr') 
        })
        action.setCallback(this , function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.dataList" , response.getReturnValue());
              //  component.set("v.homePageData" , response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        }else{
            var action = component.get("c.getSubfoldersAndFiles");
            action.setParams({
            parentfolderid : idFolder,
            accessToken : component.get('v.addr') 
        })
        action.setCallback(this , function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.dataList" , response.getReturnValue());
                component.set("v.showTable" , false);
                component.set("v.showTable" , true);
            };
        });
        $A.enqueueAction(action);
        }
    }
})