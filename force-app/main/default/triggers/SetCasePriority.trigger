trigger SetCasePriority on Case (before insert) {
    
    for(Case rec: Trigger.new){
        if(rec.origin == 'Phone'){
            rec.Priority = 'High';
        }
    }

}