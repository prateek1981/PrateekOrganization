({
	init : function(component, event, helper) {
        var haveToDisplay = true;      
        component.set("v.toBeDisplay", haveToDisplay);
		helper.getData(component, event, helper);
	},
	handleChangeForObject : function(component, event, helper){ 
        var haveToDisplay = false;      
        component.set("v.toBeDisplay", haveToDisplay);
        component.set("v.selectedFields","");
		helper.getAllFields(component, event, helper);
    },
    handleChange : function(component, event, helper){ 
        var haveToDisplay = false;      
        var isPro = false;
        component.set("v.toBeDisplay", haveToDisplay);
		helper.getAllFields(component, event, helper);
        if(component.get('v.selectedFields').length > 0){
            component.set("v.isProcess",isPro);
        }
        else{
            component.set("v.isProcess",true);
        }
    },
    fetchRecords : function(component , event , helper){
        var haveToDisplay = true;
        component.set("v.toBeDisplay", haveToDisplay);
        helper.handleButtonClick(component , event , helper);
    }
})