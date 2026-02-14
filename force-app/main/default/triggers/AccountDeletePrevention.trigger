trigger AccountDeletePrevention on Account (before delete) {
    
    for(Account acc:Trigger.old){
        
        if(acc.AnnualRevenue != null && acc.AnnualRevenue > 1000000){
            
            acc.addError('Amount greater than 1000000.Can not delete the account');
        }
    }

}