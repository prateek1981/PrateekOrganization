Trigger TriggerAssignment on Contact(before Insert, after delete,after undelete,before update){
    TriggerAssignmentCases tac=new TriggerAssignmentCases();
    if(Trigger.isInsert && Trigger.isbefore ){
        if(!TriggerAssignmentCases.prevent_rec){
            TriggerAssignmentCases.prevent_rec=true;
             tac.insertcase(Trigger.new);
        }
        
    }
    else if(Trigger.isDelete && Trigger.isafter ){
                if(!TriggerAssignmentCases.prevent_rec){
            TriggerAssignmentCases.prevent_rec=true;
                 tac.deletecase();
        }
       
    }
    else if(Trigger.isUndelete && Trigger.isAfter){
                if(!TriggerAssignmentCases.prevent_rec){
            TriggerAssignmentCases.prevent_rec=true;
            tac.undeletecase(Trigger.new);
        }
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
                    if(!TriggerAssignmentCases.prevent_rec){
                         TriggerAssignmentCases.prevent_rec=true;
                          TriggerAssignmentCases.contactsUpdated(Trigger.new,Trigger.old);
                    }
        
       
    }
}