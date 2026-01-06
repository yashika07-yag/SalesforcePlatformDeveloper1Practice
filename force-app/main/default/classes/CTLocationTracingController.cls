public with sharing class CTLocationTracingController {
    
    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c,Person__r.Token__c,Person__r.Health_Status__c FROM Location_Tracing__c 
        where Id =: locationId
        ORDER BY Visit_Date__c DESC];
    }
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){

        return [SELECT Id, Person__c, Location__c, Visit_Date__c,Person__r.Token__c,Person__r.Health_Status__c FROM Location_Tracing__c 
        where Person__c IN :personIds
        AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){

        return [SELECT Id, Person__c, Location__c, Visit_Date__c,Person__r.Token__c,Person__r.Health_Status__c FROM Location_Tracing__c 
        where Location__c IN :locationIds
        AND Person__r.Health_Status__c = 'Green'
        AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){

        Set<Id> personIds = new Set<Id>();
        Set<Id> locationIds = new Set<Id>();
        for(Location_Tracing__c trace: newLocationTraces){
            personIds.add(trace.Person__c);
            locationIds.add(trace.Location__c);
        }

    Map<Id,set<Id>> mapofExistingRecords = new Map<Id,set<Id>>();
    List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

    List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c, Visit_Date__c,Person__r.Token__c,Person__r.Health_Status__c FROM Location_Tracing__c 
        where Location__c IN :locationIds
        AND Person__c IN :personIds];

    if(existingRecords!= null && existingRecords.size() > 0){
        for(Location_Tracing__c trace: existingRecords){
            if(!mapofExistingRecords.containsKey(trace.Location__c)){
                mapofExistingRecords.put(trace.Location__c, new set<Id>());
            }
            mapofExistingRecords.get(trace.Location__c).add(trace.Person__c);

        }
    
        for(Location_Tracing__c trace : newLocationTraces){

            if(mapofExistingRecords.containsKey(trace.Location__c) && mapofExistingRecords.get(trace.Location__c).contains(trace.Person__c)){

                duplicates.add(trace);

            }
        }
    }
        return duplicates;
}
}