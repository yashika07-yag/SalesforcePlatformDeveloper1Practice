trigger accountContactInsert on Account (after Insert, after update){
    
    Set<String> accountEmails = new set<String>();
    Map<String,Contact> conEmails = new Map<String,Contact>();
    
    for(Account acc : Trigger.new){
        if(acc.Email__c != null){
            accountEmails.add(acc.Email__c);
        }
    }
    
    for(Contact Con : [SELECT id,Email from Contact where Email IN: accountEmails]){
        
        conEmails.put(con.Email,Con);
    }
    
    List<Contact> contactstoInsert = new List<Contact>();
    
    for(Account acc : Trigger.new){
        
        if(acc.Email__c != null && !conEmails.containsKey(acc.Email__c)){
            
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.Email = acc.Email__c;
            con.AccountId = acc.Id;
            
            contactstoInsert.add(con);
            
            conEmails.put(acc.Email__c,con);
            
        }
        
        if(!contactstoInsert.isEmpty()){
            
            insert contactstoInsert;
        }
        
        
    }
    
}