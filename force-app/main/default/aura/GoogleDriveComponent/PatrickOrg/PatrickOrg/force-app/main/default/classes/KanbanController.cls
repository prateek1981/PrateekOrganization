public with sharing class KanbanController {
  @AuraEnabled(cacheable=true)
  public static List<String> getPicklistValues(String objectName, String picklistFieldName) {
    List<String> values = new List<String>();
    Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(picklistFieldName).getDescribe();
    for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
      values.add(entry.getValue());
    }
    return values;
  }

  @AuraEnabled(cacheable=true)
  public static List<SObject> getRecords(String objectName, String picklistFieldName) {
    String soql = 'SELECT Id, Name, ' + picklistFieldName + ' FROM ' + objectName;
    return Database.query(soql);
  }
} 