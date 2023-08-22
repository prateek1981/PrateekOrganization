({
  getPicklistValues: function(component) {
    const action = component.get("c.getPicklistValues");
    action.setParams({
      objectName: component.get("v.objectName"),
      picklistFieldName: component.get("v.picklistFieldName")
    });
    action.setCallback(this, function(response) {
      if (response.getState() === "SUCCESS") {
        component.set("v.picklistValues", response.getReturnValue());
        const recordCount = {};
        response.getReturnValue().forEach(value => recordCount[value] = 0);
        component.set("v.recordCount", recordCount);
      } else {
        console.error(response.getError());
      }
    });
    $A.enqueueAction(action);
  },

  getRecords: function(component) {
    const action = component.get("c.getRecords");
    action.setParams({
      objectName: component.get("v.objectName"),
      picklistFieldName: component.get("v.picklistFieldName")
    });
    action.setCallback(this, function(response) {
      if (response.getState() === "SUCCESS") {
        const records = response.getReturnValue();
        component.set("v.records", records);
        const recordCount = component.get("v.recordCount");
        records.forEach(record => recordCount[record[component.get("v.picklistFieldName")]]++);
        component.set("v.recordCount", recordCount);
      } else {
        console.error(response.getError());
      }
    });
    $A.enqueueAction(action);
  }
})