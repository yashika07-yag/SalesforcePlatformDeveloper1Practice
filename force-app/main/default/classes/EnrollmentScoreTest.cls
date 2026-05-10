@isTest
private class EnrollmentScoreTest {

    /*
     * Test Data Setup
     */
    @testSetup
    static void setupData() {

        List<Contact> contacts =
            new List<Contact>();

        contacts.add(
            new Contact(
                LastName = 'Doe',
                Email = 'jane.doe@example.com'
            )
        );

        contacts.add(
            new Contact(
                LastName = 'Smith',
                Email = 'john.smith@example.com'
            )
        );

        insert contacts;
    }

    /*
     * REST API - Positive Test
     */
    @isTest
    static void testSaveScores_Positive() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        req.requestURI =
            '/services/apexrest/enrollment-scores/';

        req.httpMethod = 'POST';

        String requestBody =
        '{' +
            '"scores": [' +
                '{' +
                    '"contactEmail":"jane.doe@example.com",' +
                    '"score":85,' +
                    '"recommendedAction":"Schedule Call",' +
                    '"sourceSystem":"EDMO Bot v2",' +
                    '"scoredAt":"2026-03-10T10:30:00Z"' +
                '}' +
            ']' +
        '}';

        req.requestBody =
            Blob.valueOf(requestBody);

        Test.startTest();

        List<EnrollmentScoreRest.ScoreResponse> responseList =
            EnrollmentScoreRest.saveScores();

        Test.stopTest();

        /*
         * Assertions
         */
        System.assertEquals(
            1,
            responseList.size()
        );

        System.assertEquals(
            true,
            responseList[0].success
        );

        List<Enrollment_Score__c> scores = [

            SELECT Id,
                   Score__c,
                   Recommended_Action__c

            FROM Enrollment_Score__c
        ];

        System.assertEquals(
            1,
            scores.size()
        );

        System.assertEquals(
            85,
            scores[0].Score__c
        );
    }

    /*
     * REST API - Negative Test
     * Contact Not Found
     */
    @isTest
    static void testSaveScores_ContactNotFound() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        req.requestURI =
            '/services/apexrest/enrollment-scores/';

        req.httpMethod = 'POST';

        String requestBody =
        '{' +
            '"scores": [' +
                '{' +
                    '"contactEmail":"invalid@example.com",' +
                    '"score":45,' +
                    '"recommendedAction":"Send Email",' +
                    '"sourceSystem":"EDMO Bot v2",' +
                    '"scoredAt":"2026-03-10T10:30:00Z"' +
                '}' +
            ']' +
        '}';

        req.requestBody =
            Blob.valueOf(requestBody);

        Test.startTest();

        List<EnrollmentScoreRest.ScoreResponse> responseList =
            EnrollmentScoreRest.saveScores();

        Test.stopTest();

        /*
         * Assertions
         */
        System.assertEquals(
            1,
            responseList.size()
        );

        System.assertEquals(
            false,
            responseList[0].success
        );

        System.assertEquals(
            'Contact not found',
            responseList[0].message
        );
    }

    /*
     * REST API - Bulk Test
     */
    @isTest
    static void testSaveScores_Bulk() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        req.requestURI =
            '/services/apexrest/enrollment-scores/';

        req.httpMethod = 'POST';

        String requestBody =
        '{' +
            '"scores": [' +

                '{' +
                    '"contactEmail":"jane.doe@example.com",' +
                    '"score":90,' +
                    '"recommendedAction":"Call",' +
                    '"sourceSystem":"EDMO",' +
                    '"scoredAt":"2026-03-10T10:30:00Z"' +
                '},' +

                '{' +
                    '"contactEmail":"john.smith@example.com",' +
                    '"score":60,' +
                    '"recommendedAction":"Email",' +
                    '"sourceSystem":"EDMO",' +
                    '"scoredAt":"2026-03-10T10:31:00Z"' +
                '},' +

                '{' +
                    '"contactEmail":"jane.doe@example.com",' +
                    '"score":40,' +
                    '"recommendedAction":"Info Pack",' +
                    '"sourceSystem":"EDMO",' +
                    '"scoredAt":"2026-03-10T10:32:00Z"' +
                '},' +

                '{' +
                    '"contactEmail":"john.smith@example.com",' +
                    '"score":82,' +
                    '"recommendedAction":"Schedule Call",' +
                    '"sourceSystem":"EDMO",' +
                    '"scoredAt":"2026-03-10T10:33:00Z"' +
                '},' +

                '{' +
                    '"contactEmail":"invalid@example.com",' +
                    '"score":50,' +
                    '"recommendedAction":"Retry",' +
                    '"sourceSystem":"EDMO",' +
                    '"scoredAt":"2026-03-10T10:34:00Z"' +
                '}' +

            ']' +
        '}';

        req.requestBody =
            Blob.valueOf(requestBody);

        Test.startTest();

        List<EnrollmentScoreRest.ScoreResponse> responseList =
            EnrollmentScoreRest.saveScores();

        Test.stopTest();

        /*
         * Assertions
         */
        System.assertEquals(
            5,
            responseList.size()
        );

        Integer successCount = 0;
        Integer failureCount = 0;

        for(
            EnrollmentScoreRest.ScoreResponse response :
            responseList
        ) {

            if(response.success) {
                successCount++;
            } else {
                failureCount++;
            }
        }

        System.assertEquals(
            4,
            successCount
        );

        System.assertEquals(
            1,
            failureCount
        );
    }

    /*
     * Trigger Test
     */
    @isTest
    static void testTriggerPriorityUpdate() {

        Contact con = [

            SELECT Id,
                   Enrollment_Priority__c

            FROM Contact

            WHERE Email = 'jane.doe@example.com'

            LIMIT 1
        ];

        /*
         * Insert Enrollment Score
         */
        Enrollment_Score__c score =
            new Enrollment_Score__c(

                Contact__c = con.Id,
                Score__c = 85,
                Recommended_Action__c = 'Schedule Call',
                Source_System__c = 'EDMO',
                Scored_At__c = System.now()
            );

        Test.startTest();

        insert score;

        Test.stopTest();

        /*
         * Verify Contact Updated
         */
        Contact updatedContact = [

            SELECT Id,
                   Enrollment_Priority__c

            FROM Contact

            WHERE Id = :con.Id
        ];

        System.assertEquals(
            'Hot',
            updatedContact.Enrollment_Priority__c
        );
    }

    /*
     * Trigger Test
     * Latest Scored_At__c Wins
     */
    @isTest
    static void testLatestScoreWins() {

        Contact con = [

            SELECT Id

            FROM Contact

            WHERE Email = 'john.smith@example.com'

            LIMIT 1
        ];

        List<Enrollment_Score__c> scoreList =
            new List<Enrollment_Score__c>();

        scoreList.add(
            new Enrollment_Score__c(
                Contact__c = con.Id,
                Score__c = 40,
                Recommended_Action__c = 'Info',
                Source_System__c = 'EDMO',
                Scored_At__c =
                    Datetime.now().addMinutes(-10)
            )
        );

        scoreList.add(
            new Enrollment_Score__c(
                Contact__c = con.Id,
                Score__c = 90,
                Recommended_Action__c = 'Call',
                Source_System__c = 'EDMO',
                Scored_At__c =
                    Datetime.now()
            )
        );

        Test.startTest();

        insert scoreList;

        Test.stopTest();

        Contact updatedContact = [

            SELECT Enrollment_Priority__c

            FROM Contact

            WHERE Id = :con.Id
        ];

        /*
         * Latest Score = 90
         * Therefore Hot
         */
        System.assertEquals(
            'Hot',
            updatedContact.Enrollment_Priority__c
        );
    }
}