public with sharing class EnrollmentScoreController {

    @AuraEnabled(cacheable=true)
    public static Enrollment_Score__c getLatestScore(
        Id contactId
    ) {

        /*
         * Validate Input
         */
        if(contactId == null) {
            return null;
        }

        /*
         * Query Latest Enrollment Score
         */
        List<Enrollment_Score__c> scoreList = [

            SELECT Id,
                   Score__c,
                   Recommended_Action__c,
                   Source_System__c,
                   Scored_At__c,
                   Contact__c

            FROM Enrollment_Score__c

            WHERE Contact__c = :contactId

            ORDER BY Scored_At__c DESC

            LIMIT 1
        ];

        /*
         * Handle No Data Scenario
         */
        if(scoreList.isEmpty()) {
            return null;
        }

        /*
         * Enforce Field Level Security
         */
        SObjectAccessDecision securityDecision =
            Security.stripInaccessible(
                AccessType.READABLE,
                scoreList
            );

        List<SObject> accessibleRecords =
            securityDecision.getRecords();

        /*
         * Return Secured Record
         */
        return (Enrollment_Score__c)
            accessibleRecords[0];
    }
}