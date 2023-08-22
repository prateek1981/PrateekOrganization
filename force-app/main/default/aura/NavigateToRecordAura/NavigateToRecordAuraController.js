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
    }
})
