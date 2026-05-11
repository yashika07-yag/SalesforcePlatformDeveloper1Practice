trigger OpportunityRollup on Opportunity(after insert, after update, after delete, after Undelete){

    set<Id>AccountIds = new set<Id>();

    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){

        for(Opportunity opp : Trigger.new){
            if(opp.AccountId != null){
                AccountIds.add(opp.AccountId);
            }
        }
    }

    if(Trigger.isDelete || Trigger.isUpdate){

        for(Opportunity opp : Trigger.old){
            if(opp.AccountId != null){
                AccountIds.add(opp.AccountId);
            }
        }
    }

    if(!AccountIds.isempty()){
        RollUpHandler.updateOpportunityAmount(accountIds);
    }
}