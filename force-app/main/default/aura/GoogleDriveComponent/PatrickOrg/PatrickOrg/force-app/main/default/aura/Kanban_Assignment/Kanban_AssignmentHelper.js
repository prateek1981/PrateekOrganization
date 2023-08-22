({
	takeObjectListHelper : function(component) {
		var action=component.get("c.giveObjects");
         action.setCallback(this, function(response){
           if(response.getState() == "SUCCESS"){
               
               var tempobjs=[];
               var objectresult=response.getReturnValue();
               
               tempobjs.push({ value:'None', label:'None'});
               for (var m in objectresult) {
                    tempobjs.push({ value:m, label:objectresult[m]});
			    }
               tempobjs.sort();
           component.set("v.objectName",tempobjs);
               
           }
       });
       $A.enqueueAction(action);
	},
     ShowFieldList : function (component,event){
        const options =[];
        var field=component.get("c.inputfields");
        field.setParams({
            objname:component.get("v.selectedObject")
        })
        field.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                var tempfields=[];
                tempfields.push({ value:'None', label:'None'});
                const allvalues=response.getReturnValue();
                for (var m in allvalues) {
					tempfields.push({ value:m, label:allvalues[m]});
				}
            	tempfields.sort();
                    component.set("v.fieldsName",tempfields);
            		component.set("v.showfield",true);
            }
        });
         $A.enqueueAction(field);
    },
    fetchPicklistValues : function (component,event) {
        console.log("Its woring");
		var act=component.get("c.picklistValues");
         act.setParams({
            objname:component.get("v.selectedObject"),
            sfield:component.get("v.selectedFieldValues")
        })
        act.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
               var tempobjs=[];
               var objectresult=response.getReturnValue();
               
               tempobjs.push({ value:'None', label:'None'});
               for (var m in objectresult) {
                   tempobjs.push({ value:objectresult[m], label:objectresult[m]});
			    }
                component.set("v.picklistVal",tempobjs);
            }
        });
       $A.enqueueAction(act);
        
	}
})