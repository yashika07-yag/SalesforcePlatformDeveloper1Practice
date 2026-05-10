import { LightningElement, api, wire } from 'lwc';

import getLatestScore
from '@salesforce/apex/EnrollmentScoreController.getLatestScore';

export default class EnrollmentScoreCard
extends LightningElement {

    @api recordId;

    scoreRecord;
    error;

    @wire(getLatestScore, { contactId: '$recordId' })
    wiredScore({ data, error }) {

        if(data) {
            this.scoreRecord = data;
            this.error = undefined;
        }
        else if(error) {
            this.error = error;
        }
    }

    get badgeClass() {

        if(!this.scoreRecord) return '';

        let score = this.scoreRecord.Score__c;

        if(score >= 80) {
            return 'slds-theme_error';
        }
        else if(score >= 50) {
            return 'slds-theme_warning';
        }

        return 'slds-theme_info';
    }
}