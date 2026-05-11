public class RollUpHandler {
    public static void updateOpportunityAmount(Set<Id> accountIds){

        Map<Id,Decimal> Amounttoaccount = new Map<Id,Decimal>();

        for(AggregateResult ar : [SELECT AccountId accId, SUM(Amount) Total FROM Opportunity where AccountId in : accountIds and StageName = 'Closed Won' Group By AccountId]){

            Amounttoaccount.put( (Id)ar.get('accId'), (Decimal) ar.get('Total'));
        }

        List<Account> accountstoUpdate = new List<Account>();

        for(Id accId : accountIds){
            
            Account acc = new Account();
            acc.Id = accId;
            acc.Total_Opportunity_Amount__c = Amounttoaccount.containskey(accId) ? Amounttoaccount.get(accId) : 0;

            accountstoUpdate.add(acc);
        }

        if(!accountstoUpdate.isEmpty())
        {
            update accountstoUpdate;
        }

    }
}