trigger LeadLastNameUpper on Lead (before insert,before update) {
    
    for(Lead leadrec: Trigger.new){
        
    if(leadrec.lastname != null){
        
        leadrec.lastname = leadrec.LastName.touppercase();
        
    }
    system.debug('leadrec.lastname-->'+ leadrec.LastName);
    }

}