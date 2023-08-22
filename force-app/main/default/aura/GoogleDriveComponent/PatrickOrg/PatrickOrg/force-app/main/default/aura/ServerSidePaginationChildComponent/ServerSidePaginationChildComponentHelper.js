({
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.records");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.records", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    getRecordsList : function(component , pageNumber , pageSize){
        component.set("v.pageNumber" , pageNumber);
        var action = component.get("c.getData");
        action.setParams({
            currentPage : pageNumber,
            limitSize : pageSize,
            objectName : component.get('v.selectedObj'),
            selectedFields : component.get('v.selectedField'),
            recordId : component.get('v.recordId')
        });
        action.setCallback(this , function(response){
            component.set("v.records" , response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getAllData : function(component, pageNumber, pageSize) {
        component.set("v.pageNumber" , pageNumber);
        var size = component.find("record").get("v.value");
        component.set("v.pageSize",size);
        var selectedFields = component.get('v.selectedField');
        if (selectedFields.length > 0) {
            var action = component.get("c.getRecords");
            action.setParams({
                objectName : component.get('v.selectedObj'),
                selectedFields: component.get('v.selectedField'),
                recordId : component.get('v.recordId'),
                limitSize : pageSize,
                currentPage : pageNumber
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records = response.getReturnValue();
                    var recordsToBeDisplayed = [];
                    component.set("v.records", records);
                    for(let i = 0;i< selectedFields.length;i++){
                        recordsToBeDisplayed.push({label:[selectedFields[i]], fieldName: [selectedFields[i]] , type:'text' , sortable : "true"});
                    }
                    component.set('v.myColumns', recordsToBeDisplayed);
                    var listRecords = [];
                    var list2 = component.get('v.allSelectedRows');
                    for(var i = 0 ; i < list2.length ; i++){
                        listRecords.push(list2[i]);
                    }
                    component.set("v.selectedRowsA" , listRecords);
                }
                else {
                    console.log("Failed with state: " + state);
                }
            });
            $A.enqueueAction(action);
        }
        else {
            component.set("v.records", []);
            component.set("v.myColumns", []);
        }
        if(selectedFields.length > 0){
            var action2= component.get("c.getRecordCount");
            action2.setParams({
                objName : component.get('v.selectedObj')
            });
            action2.setCallback(this, function(response2) {
                var state2 = response2.getState();
                if(state2 === "SUCCESS") {
                    var records2 = response2.getReturnValue();
                    component.set("v.totalRecords",records2);
                    component.set("v.totalPages",Math.ceil(component.get('v.totalRecords')/component.get('v.pageSize')));
                }
                else {
                    console.log("Failed with state: " + state);
                }
            });
            $A.enqueueAction(action2);
        } 
    }  
})