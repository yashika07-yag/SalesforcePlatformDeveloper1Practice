trigger AccountTypeUpdate on Account (before insert) {
    
    for(Account acc : Trigger.new){

        if(acc.industry == 'Banking'){
            acc.type = 'customer';
        }

    }
}