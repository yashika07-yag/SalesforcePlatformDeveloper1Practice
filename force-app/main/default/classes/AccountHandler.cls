public class AccountHandler {

    public static void handleAfterUpsert(List<Account> AccountsList){

        Set<String> emailSet = new Set<String>();

        for (Account acc : AccountsList){
            if(acc.Email__c != null){
                emailSet.add(acc.Email__c);
            }
        }   
        system.debug('EmailSet--->'+emailSet);

        if(emailSet.isEmpty()) {return;}

        Map<String,Contact> existingContactMap = new Map<String,Contact>();

        for(Contact con : [SELECT Id,Email,AccountId,Name from Contact WHERE Email IN : emailSet]){

            existingContactMap.put(con.Email, con);
            system.debug('con--->'+con);

        }
        system.debug('existingContactMap--->'+existingContactMap);
         
        List<Contact> contactsToUpsert = new List<Contact>();

        for(Account acc : AccountsList){

            if(acc.Email__c == null) continue;
            
            system.debug('Entering the loop--->');
            
            if (existingContactMap.containsKey(acc.Email__c)) {

                Contact existingCon = existingContactMap.get(acc.Email__c);
                existingCon.AccountId = acc.Id;
                existingCon.Description = acc.Description;
                contactsToUpsert.add(existingCon);
                system.debug('Entering existingCon--->'+existingCon);
                system.debug('Entering contactsToUpsert--->'+contactsToUpsert);

            } else {
                Contact newCon = new Contact();
                newCon.AccountId = acc.Id;
                newCon.Email = acc.Email__c;
                newCon.LastName = acc.Name;
                contactstoUpsert.add(newCon);
                system.debug('Entering contactsToUpsert--->'+contactsToUpsert);
            }

            
        }
        if(!contactstoUpsert.isEmpty()){
                Upsert contactsToUpsert;
            }
    }

}