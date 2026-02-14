trigger OpportunityStageUpdate on Opportunity (before update) {
    
    for(Opportunity ops : Trigger.new){
        
        Opportunity ExisitngOpp = Trigger.OldMap.get(ops.Id); 
        
        if(ExisitngOpp.stageName == 'Closed Won' && ops.stageName != 'closed Won'){
            ops.addError('Stage can not be updated once it is closed Won');
        }
    }

}