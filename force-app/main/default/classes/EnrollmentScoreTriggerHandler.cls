public with sharing class EnrollmentScoreTriggerHandler {

    public static void handleAfterInsert(
        List<Enrollment_Score__c> newScores
    ) {

        /*
         * Store latest score per Contact
         * Requirement:
         * Latest Scored_At__c wins
         */
        Map<Id, Enrollment_Score__c> latestScoreMap =
            new Map<Id, Enrollment_Score__c>();

        /*
         * Find latest score for each Contact
         */
        for(Enrollment_Score__c scoreRecord : newScores) {

            if(scoreRecord.Contact__c == null) {
                continue;
            }

            /*
             * If Contact not already added
             */
            if(
                !latestScoreMap.containsKey(
                    scoreRecord.Contact__c
                )
            ) {

                latestScoreMap.put(
                    scoreRecord.Contact__c,
                    scoreRecord
                );
            }

            /*
             * Compare Scored_At__c
             * Keep latest record only
             */
            else {

                Enrollment_Score__c existingRecord =
                    latestScoreMap.get(
                        scoreRecord.Contact__c
                    );

                if(
                    scoreRecord.Scored_At__c != null &&
                    existingRecord.Scored_At__c != null &&
                    scoreRecord.Scored_At__c >
                    existingRecord.Scored_At__c
                ) {

                    latestScoreMap.put(
                        scoreRecord.Contact__c,
                        scoreRecord
                    );
                }
            }
        }

        /*
         * Prepare Contacts for update
         */
        List<Contact> contactsToUpdate =
            new List<Contact>();

        /*
         * Determine Priority
         */
        for(Id contactId : latestScoreMap.keySet()) {

            Enrollment_Score__c latestScore =
                latestScoreMap.get(contactId);

            String priority;

            /*
             * Priority Logic
             */
            if(latestScore.Score__c >= 80) {

                priority = 'Hot';

            } else if(latestScore.Score__c >= 50) {

                priority = 'Warm';

            } else {

                priority = 'Cold';
            }

            contactsToUpdate.add(
                new Contact(
                    Id = contactId,
                    Enrollment_Priority__c = priority
                )
            );
        }

        /*
         * Single DML
         */
        if(!contactsToUpdate.isEmpty()) {

            update contactsToUpdate;
        }
    }
}