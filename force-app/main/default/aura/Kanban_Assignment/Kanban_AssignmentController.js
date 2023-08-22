({
takeObjectList : function(component, event, helper) {
		helper.takeObjectListHelper(component);
	},
     addFields : function(component, event, helper) {
         helper.ShowFieldList(component,event);
         component.set("v.showfield",true);
         component.set("v.showrec",false);
	},
    pickValues : function(component, event, helper) {
         helper.fetchPicklistValues(component,event);
        setTimeout(() => {
            if(component.get("v.showrec")===false){
            component.set("v.showrec",true);
        }
                   else{
                   	 component.set("v.showrec",true);
                   }
        }, 2000)
	}
})