({
    getData: function(component, event, helper) {
        var size = component.find("record").get("v.value");
        component.set("v.pageSize",size);
        var selectedFields = component.get('v.selectedField');
        
        component.set("v.pageSize",size);
        if (selectedFields.length > 0) {
            var action = component.get("c.getRecords");
            action.setParams({
                objectName : component.get('v.selectedObj'),
                selectedFields: component.get('v.selectedField'),
                recordId : component.get('v.recordId'),
                limitSize : component.get('v.pageSize'),
                currentPage : component.get('v.pageNumber')
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
    },
    getSortedData : function(component , event , helper){
        var sortedBy = event.getParam('fieldName');
        var sortedDirection = event.getParam('sortDirection');
        var isAscen = component.get('v.isAscending');
        if(isAscen){
            sortedDirection = 'desc';
            component.set("v.isAscending",false);
        }
        else{
            component.set("v.isAscending", true);
            sortedDirection = 'asc';
        }
        component.set("v.sortedBy", sortedBy);
        component.set("v.sortedDirection" , sortedDirection);
        helper.sortData(component , sortedBy , sortedDirection);
    },
    handleFirst : function(component ,event , helper){
        var pageNumber = component.get('v.pageNumber');
        var pageSize = component.find('record').get('v.value');
        pageNumber = 1;
        helper.getAllData(component , pageNumber , pageSize);
        var listRecords = [];
        var list2 = component.get('v.allSelectedRows');
        for(var i = 0 ; i < list2.length ; i++){
            listRecords.push(list2[i]);
        }
        component.set("v.selectedRowsA" , listRecords);
    },
    handlePrevious : function(component , event , helper){
        var pageNumber = component.get('v.pageNumber');
        var pageSize = component.find('record').get('v.value');
        pageNumber--;
        helper.getAllData(component , pageNumber , pageSize);
        var listRecords = [];
        var list2 = component.get('v.allSelectedRows');
        for(var i = 0 ; i < list2.length ; i++){
            listRecords.push(list2[i]);
        }
        component.set("v.selectedRowsA" , listRecords);
    },
    handleNext : function(component ,event , helper){
        var pageNumber = component.get('v.pageNumber');
        var pageSize = component.find('record').get('v.value');
        pageNumber++;
        helper.getAllData(component , pageNumber , pageSize);
        var listRecords = [];
        var list2 = component.get('v.allSelectedRows');
        for(var i = 0 ; i < list2.length ; i++){
            listRecords.push(list2[i]);
        }
        component.set("v.selectedRowsA" , listRecords);
    },
    handleLast : function(component ,event , helper){
        
        var pageNumber = component.get('v.pageNumber');
        var pageSize = component.find('record').get('v.value');
        pageNumber = Math.ceil(component.get('v.totalRecords')/component.get('v.pageSize'));
        helper.getAllData(component , pageNumber , pageSize);
        var listRecords = [];
        var list2 = component.get('v.allSelectedRows');
        for(var i = 0 ; i < list2.length ; i++){
            listRecords.push(list2[i]);
        }
        component.set("v.selectedRowsA" , listRecords);
    },
    onRowsSelection : function(component , evt , helper){
        var data = component.get('v.records');
        var updatedItemList = [];
        var selectedItemList = component.get('v.allSelectedRows');
        let loadedItemsSet = new Set();
        data.forEach((ele) => {
            loadedItemsSet.add(ele.Id);
        });
        if (evt.getParam('selectedRows')) { 
            evt.getParam('selectedRows').map((event) => {
                var idVar = event.Id;
                updatedItemList.push(idVar);
            });
            updatedItemList.forEach((id) => {
                if (!selectedItemList.includes(id)) {
                    selectedItemList.push(id);
                }
            });        
        }
        loadedItemsSet.forEach((id) => {
            if (selectedItemList.includes(id) && !updatedItemList.includes(id)) {
                selectedItemList.splice(selectedItemList.indexOf(id),1);
            }
        });
        component.set("v.allSelectedRows" , selectedItemList);
        var listFinal = [];
        for(var i = 0 ; i < selectedItemList.length ; i++){
            listFinal.push(selectedItemList[i]);
        }
        component.set("v.selectedRowsA" ,listFinal);
    }
})