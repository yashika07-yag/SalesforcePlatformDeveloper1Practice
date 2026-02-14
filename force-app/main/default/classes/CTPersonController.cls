public with sharing class CTPersonController {
    public static String getToken(String mobileNo){
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5',value);

        //get the string value to hash blob
        return EncodingUtil.base64Encode(hash);
        
     }

     public static List<Person__c> getRecentHealthChanges(){
      
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
     }

     public static List<Person__c> searchPeople(String searchTerm){

      searchTerm = searchTerm + '%';
      return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
     }
      
     public static Person__c getPersonById(String personId){

      List<Person__c> people =  [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c WHERE Id =: personId];
      if(people != null && people.size() > 0){
        return people[0];
     }
     return null;
   }

   public static Map<string, Integer> getHealthStatusCount(){

     Map<String,Integer> healthcountMap = new Map<String,Integer>();
     for(AggregateResult ar : [SELECT Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c]){

       String healthStatus = String.valueOf(ar.get('Health_Status__c'));
       Integer count = Integer.valueOf(ar.get('total'));
      healthcountMap.put(healthStatus,count);
      }
      return healthcountMap;

   }

}