({

	getData : function(component, event, helper) {
		var action = component.get("c.getAllObject");
		action.setCallback(this, function(response) {
			var state = response.getState();
				if (state === "SUCCESS" || state === "DRAFT") {
					var result = response.getReturnValue();
					var listofObjects = [];
					for(var key in result){
						listofObjects.push({key: key, value: result[key]});
					}
					component.set("v.allObject", listofObjects);                   
				}
            	else{
						console.log("Unknown error");
				}
			});
			$A.enqueueAction(action);
		},
		getAllFields : function(component, event, helper){
		var action = component.get("c.getAllField");
			action.setParams({
				objectName : component.get('v.selectedObject'),
			})
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS" || state === "DRAFT") {
					var result = response.getReturnValue();
                    var listofFields = [];
					var fieldLabelList = [];
					for(var key in result){
						listofFields.push({value: key, label: result[key]});
					}
                    component.set("v.allField", listofFields);
				}
                else {
						console.log("Unknown error");
				}
			});
		$A.enqueueAction(action);	
   },
})