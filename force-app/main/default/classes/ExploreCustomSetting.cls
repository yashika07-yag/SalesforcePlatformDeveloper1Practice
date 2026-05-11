public class ExploreCustomSetting {
    public static void retrieveValue(){

        Id userid = [SELECT Id from User where Name = 'Integration User' LIMIT 1].id;
        System.debug('Instance Default : ' + StopTrigger__c.getInstance());
        System.debug('Instance Default : ' + StopTrigger__c.getInstance(UserInfo.getUserID()));
        System.debug('Org Defaults : ' + StopTrigger__c.getOrgDefaults());
        System.debug('Values Default: ' + StopTrigger__c.getValues(UserInfo.getUserID()));
        System.debug('Instance Default : ' + StopTrigger__c.getInstance(userid));
    }
}