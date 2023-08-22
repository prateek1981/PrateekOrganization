({
  init: function(component, event, helper) {
    // get the object name and picklist field name from the user
    const objectName = prompt("Enter object name:");
    const picklistFieldName = prompt("Enter picklist field name:");

    // set the component attributes
    component.set("v.objectName", objectName);
    component.set("v.picklistFieldName", picklistFieldName);

    // get the picklist values from Salesforce
    helper.getPicklistValues(component);

    // get the records from Salesforce using Apex and populate the kanban board
    helper.getRecords(component);
  }
})