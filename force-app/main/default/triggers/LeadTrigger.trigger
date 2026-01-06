trigger LeadTrigger on Lead (before insert, before update) {
    
    for(Lead LeadRecords: Trigger.new){
        if(string.isblank(LeadRecords.LeadSource))  {
	LeadRecords.LeadSource = 'Other';
        }
        
        if(String.isBlank(LeadRecords.Industry)){
            LeadRecords.adderror('The field can not be blank');
        }
        
    }
	
}