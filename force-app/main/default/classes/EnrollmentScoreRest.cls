@RestResource(urlMapping='/enrollment-scores/*')
global with sharing class EnrollmentScoreRest {

    /*
     * Request Wrapper
     */
    global class ScoreRequest {
        public List<ScoreData> scores;
    }

    /*
     * Individual Score Wrapper
     */
    global class ScoreData {
        public String contactEmail;
        public Integer score;
        public String recommendedAction;
        public String sourceSystem;
        public Datetime scoredAt;
    }

    /*
     * Response Wrapper
     */
    global class ScoreResponse {
        public String email;
        public Boolean success;
        public String message;

        public ScoreResponse(
            String email,
            Boolean success,
            String message
        ) {
            this.email = email;
            this.success = success;
            this.message = message;
        }
    }

    /*
     * REST Endpoint
     */
    @HttpPost
    global static List<ScoreResponse> saveScores() {

        List<ScoreResponse> responses =
            new List<ScoreResponse>();

        try {

            /*
             * Parse Request Body
             */
            String requestBody =
                RestContext.request.requestBody.toString();

            ScoreRequest requestData =
                (ScoreRequest) JSON.deserialize(
                    requestBody,
                    ScoreRequest.class
                );

            /*
             * Handle Empty Request
             */
            if(
                requestData == null ||
                requestData.scores == null ||
                requestData.scores.isEmpty()
            ) {

                responses.add(
                    new ScoreResponse(
                        null,
                        false,
                        'No scores received'
                    )
                );

                return responses;
            }

            /*
             * Collect Emails
             */
            Set<String> emailSet =
                new Set<String>();

            for(ScoreData score : requestData.scores) {

                if(score.contactEmail != null) {
                    emailSet.add(
                        score.contactEmail.toLowerCase()
                    );
                }
            }

            /*
             * Query Contacts Once
             */
            Map<String, Contact> contactMap =
                new Map<String, Contact>();

            for(Contact con : [
                SELECT Id, Email
                FROM Contact
                WHERE Email IN :emailSet
            ]) {

                contactMap.put(
                    con.Email.toLowerCase(),
                    con
                );
            }

            /*
             * Prepare Enrollment Score Records
             */
            List<Enrollment_Score__c> scoresToInsert =
                new List<Enrollment_Score__c>();

            /*
             * Process Each Record
             */
            for(ScoreData score : requestData.scores) {

                if(
                    score.contactEmail != null &&
                    contactMap.containsKey(
                        score.contactEmail.toLowerCase()
                    )
                ) {

                    Contact matchedContact =
                        contactMap.get(
                            score.contactEmail.toLowerCase()
                        );

                    Enrollment_Score__c enrollmentScore =
                        new Enrollment_Score__c(
                            Contact__c = matchedContact.Id,
                            Score__c = score.score,
                            Recommended_Action__c =
                                score.recommendedAction,
                            Source_System__c =
                                score.sourceSystem,
                            Scored_At__c =
                                score.scoredAt
                        );

                    scoresToInsert.add(enrollmentScore);

                    responses.add(
                        new ScoreResponse(
                            score.contactEmail,
                            true,
                            'Enrollment score created'
                        )
                    );

                } else {

                    responses.add(
                        new ScoreResponse(
                            score.contactEmail,
                            false,
                            'Contact not found'
                        )
                    );
                }
            }

            /*
             * Insert Records Once
             */
            if(!scoresToInsert.isEmpty()) {
                insert scoresToInsert;
            }

        } catch(Exception e) {

            responses.clear();

            responses.add(
                new ScoreResponse(
                    null,
                    false,
                    e.getMessage()
                )
            );
        }

        return responses;
    }
}