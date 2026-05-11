trigger SetCasePriority on Case (before insert) {

    StopTrigger__c st = StopTrigger__c.getInstance(UserInfo.getUserId());

    if(st != null && st.IsDisabled__c){
        return;
    }
    
    for(Case rec: Trigger.new){
        if(rec.origin == 'Phone'){
            rec.Priority = 'High';
        }
    }

}