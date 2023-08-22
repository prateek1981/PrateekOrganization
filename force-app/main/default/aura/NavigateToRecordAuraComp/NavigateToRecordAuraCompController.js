({
    navigateToRecord : function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            "type": "standard__recordPage",
            "attributes": {
                "recordId": "0012w00001RGjHHAA1",
                "objectApiName": "Account",
                "actionName": "view"
            }
        };
        navService.navigate(pageReference);
    },


    navigateToNewAccout : function(component, event, helper) {
        console.log('The navigate to record method is called');
        var navService = component.find("navigateToNewAccout");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'home'
            }
        };
        navService.navigate(pageReference);
    }
})
